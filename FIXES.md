# Prioritized Improvement Plan

## P0 — Critical (Security / Architecture / Broken Patterns)

---

### P0-1: IngredientsController and StepsController have no authorization

**File:** `app/controllers/ingredients_controller.rb`, `app/controllers/steps_controller.rb`

**Problem:**
Neither controller calls `authorize` on any action. Any authenticated user can view, update, or destroy any ingredient or step in the database, regardless of recipe ownership. For example, `DELETE /ingredients/1` will delete any ingredient without checking whether the current user owns the parent recipe.

**Suggested solution:**
Create Pundit policies and add `authorize` calls to every action.

```ruby
# app/policies/ingredient_policy.rb
class IngredientPolicy < ApplicationPolicy
  def index?   = user.present?
  def show?    = user.present? && record.recipe.author_id == user.id
  def create?  = user.present?
  def update?  = user.present? && record.recipe.author_id == user.id
  def destroy? = user.present? && record.recipe.author_id == user.id
end
```

```ruby
# app/policies/step_policy.rb
class StepPolicy < ApplicationPolicy
  def index?   = user.present?
  def show?    = user.present? && record.recipe.author_id == user.id
  def create?  = user.present?
  def update?  = user.present? && record.recipe.author_id == user.id
  def destroy? = user.present? && record.recipe.author_id == user.id
end
```

Then add `authorize` to each action in both controllers, e.g.:
```ruby
def update
  @the_ingredient = Ingredient.find(params[:id])
  authorize @the_ingredient  # ADD THIS
  ...
end
```

---

### P0-2: Strong params permit `:recipe_id` from user input

**File:** `app/controllers/ingredients_controller.rb:44`, `app/controllers/steps_controller.rb:43`

**Problem:**
```ruby
def ingredient_params
  params.require(:ingredient).permit(:recipe_id, :unit, :amount, :name)
end
```
A malicious user can submit a crafted form with any `recipe_id`, creating or updating an ingredient/step on a recipe they do not own. The `recipe_id` is a trust boundary that must not come from user-submitted data.

**Suggested solution:**
Remove `:recipe_id` from permitted params and assign it server-side from the authenticated context:

```ruby
# IngredientsController#create
def create
  recipe = Recipe.find(params[:recipe_id])  # or however the recipe is scoped
  authorize recipe, :update?               # verify ownership of the parent recipe
  the_ingredient = recipe.recipe_ingredients.build(ingredient_params)
  ...
end

def ingredient_params
  params.require(:ingredient).permit(:unit, :amount, :name)  # NO :recipe_id
end
```

If ingredients are only created/edited via the nested form on the recipe show page, the `recipe_id` is already embedded in the nested attributes path and the recipe-level `authorize` in `RecipesController#update` covers it. The standalone `IngredientsController` CRUD should be reviewed — if it is not actively used by the UI, consider removing it or restricting it behind the recipe authorization.

---

### P0-3: `recipe_author` fallback to `User.first` is a security smell

**File:** `app/controllers/recipes_controller.rb:68-70`

**Problem:**
```ruby
def recipe_author
  (respond_to?(:current_user) && current_user) || User.first
end
```
The `|| User.first` fallback means that if `current_user` is ever nil (e.g., if `authenticate_user!` is skipped, bypassed, or the wrong action is authorized), recipes would be created and attributed to the first user in the database. This is a latent vulnerability.

**Suggested solution:**
Trust the `authenticate_user!` before_action and remove the fallback:
```ruby
def recipe_author
  current_user
end
```
If `current_user` is nil at this point, it is a bug in the authentication layer — fail loudly rather than silently masking the issue.

---

### P0-4: PWA manifest contains unmodified template placeholders

**File:** `app/views/pwa/manifest.json.erb`

**Problem:**
```json
{
  "name": "Rails8Template",
  "description": "Rails8Template.",
  "theme_color": "red",
  "background_color": "red"
}
```
The manifest was never updated from the Rails generator defaults. A PWA with `name: "Rails8Template"` and `theme_color: "red"` does not represent the application and will create a confusing install experience for users.

**Suggested solution:**
Update the manifest to reflect the actual application:
```json
{
  "name": "Recipe Manager",
  "short_name": "Recipes",
  "description": "Upload a photo of a recipe and we'll extract the ingredients and steps.",
  "icons": [
    { "src": "/icon.png", "type": "image/png", "sizes": "512x512" },
    { "src": "/icon.png", "type": "image/png", "sizes": "512x512", "purpose": "maskable" }
  ],
  "start_url": "/",
  "display": "standalone",
  "scope": "/",
  "theme_color": "#6f42c1",
  "background_color": "#f5f3f8"
}
```

---

## P1 — Important (Maintainability / Convention / Cleanliness)

These affect code quality, conventions, and long-term maintainability.

---

### P1-1: CSS is defined in two places — inline style block duplicates application.css

**File:** `app/views/layouts/application.html.erb:27-61`, `app/assets/stylesheets/application.css`

**Problem:**
The layout file contains a 35+ line inline `<style>` block that defines rules already present in `application.css` (navbar shadow, card border-radius, button radius, primary color overrides, breadcrumb colors, pagination colors, etc.). This creates a maintenance hazard — changing a color or radius requires updating two files. It also bloats the HTML response on every page load.

**Suggested solution:**
Delete the inline `<style>` block from `application.html.erb` entirely. Confirm all rules are covered by `application.css`. Move any remaining unique rules into `application.css`. The only inline `<style>` that is justified is in `show.html.erb:7-11` (page-specific toggle animation) — that can remain as a `content_for :head` block.

---

### P1-2: Thin test coverage — infrastructure exists but is almost unused

**File:** `spec/`

**Problem:**
The RSpec setup is solid (capybara, selenium, shoulda-matchers, webmock, headless Chrome), but actual coverage is minimal: 5 real assertions in 2 spec files. Critical untested paths include: recipe creation via image upload, authorization enforcement, ingredient/step CRUD, comment creation, parsing flow, and the service objects. `spec/features/sample_spec.rb` is a boilerplate placeholder (`expect(1).to eq(1)`).

**Suggested solution:**
Start with high-value, low-effort tests:
```ruby
# spec/models/ingredient_spec.rb
RSpec.describe Ingredient, type: :model do
  it { should belong_to(:recipe) }
  it { should validate_presence_of(:name) }
end

# spec/models/comment_spec.rb
RSpec.describe Comment, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:commentable) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body).is_at_most(2000) }
end
```

Add request specs for the authorization gaps (once P0-1 is fixed):
```ruby
# spec/requests/ingredients_request_spec.rb
describe "DELETE /ingredients/:id" do
  it "does not allow deletion of another user's ingredient" do
    owner = create(:user)
    other = create(:user)
    recipe = create(:recipe, author: owner)
    ingredient = create(:ingredient, recipe: recipe)
    sign_in other
    delete ingredient_path(ingredient)
    expect(response).to redirect_to(root_path)
  end
end
```

Delete `spec/features/sample_spec.rb` or replace it with a real feature spec.

---

### P1-3: Commented-out gems in Gemfile should be deleted

**File:** `Gemfile`

**Problem:**
11 gems are commented out with notes indicating they are unused: `http`, `rollbar`, `ai-chat`, `mini_magick`, `httparty`, `image_processing`, `factory_bot_rails`, `draft_generators`, `haikunator`, `rails-controller-testing`. Per code hygiene standards, unused code should be deleted rather than commented out. These add noise and suggest the Gemfile is a working document rather than a clean dependency list. If documentation of rejected options is desired, a `docs/` file or git history serves that purpose better.

**Suggested solution:**
Delete all 11 commented-out gem lines. They can be retrieved from git history if needed.

---

### P1-4: hello_controller.js is unused boilerplate

**File:** `app/javascript/controllers/hello_controller.js`

**Problem:**
The default Stimulus `hello_controller.js` from the Rails generator is present but never used in any view. It imports `Controller` and sets `this.element.textContent = "Hello, Stimulus!"` — pure boilerplate.

**Suggested solution:**
Delete the file. Confirm it is not referenced in `app/javascript/controllers/index.js`.

---

### P1-5: Missing foreign key constraints in schema for recipes, ingredients, and steps

**File:** `db/schema.rb`

**Problem:**
```ruby
# recipes table
t.integer "author_id"   # should be bigint with FK constraint

# ingredients table
t.integer "recipe_id"   # should be bigint with FK constraint

# steps table
t.integer "recipe_id"   # should be bigint with FK constraint
```
These columns use `integer` instead of `bigint` (inconsistent with other FK columns like `comments.user_id` which is `bigint`). More importantly, none of these have `add_foreign_key` declarations in the schema, meaning the database does not enforce referential integrity. Deleting a User does not cascade-delete their recipes at the DB level (only via Rails callbacks).

**Suggested solution:**
Create a migration to fix column types and add FK constraints:
```ruby
class FixForeignKeyConstraints < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :recipes, :users, column: :author_id
    add_foreign_key :ingredients, :recipes
    add_foreign_key :steps, :recipes
  end
end
```

---

### P1-6: Duplicate updateDOM logic across two Stimulus controllers

**File:** `app/javascript/controllers/ajax_recipe_form_controller.js:65-89`, `app/javascript/controllers/recipe_channel_controller.js:34-47`

**Problem:**
Both controllers implement nearly identical `updateDOM(recipe)` methods that update `#recipe_title_display` and `#recipe_source_display`. This is a DRY violation in the JavaScript layer — if the DOM structure changes, both files must be updated.

**Suggested solution:**
Extract a shared utility:
```javascript
// app/javascript/recipe_dom.js
export function updateRecipeDOM(recipe) {
  const titleEl = document.getElementById("recipe_title_display")
  const sourceEl = document.getElementById("recipe_source_display")
  if (titleEl && recipe.title != null) titleEl.textContent = recipe.title
  // ... etc
}
```
Import in both controllers: `import { updateRecipeDOM } from "../recipe_dom"`

---

### P1-7: Bug in Recipe#apply_parsed_data — shadows self.errors with local variable

**File:** `app/models/recipe.rb:44`

**Problem:**
```ruby
def apply_parsed_data(parsed_data)
  ok = update(...)
  return [true, nil] if ok
  errors = errors.full_messages.to_a  # shadows self.errors with local var
  recipe_ingredients.each { |i| errors.concat(i.errors.full_messages) }
  ...
end
```
`errors = errors.full_messages.to_a` assigns a local variable named `errors`, shadowing the `self.errors` method. In Ruby this works because the RHS evaluates `self.errors` before the assignment takes effect, but Rubocop will flag it and it confuses readers into thinking `errors` is redefined before use.

**Suggested solution:**
```ruby
all_errors = errors.full_messages.to_a
recipe_ingredients.each { |i| all_errors.concat(i.errors.full_messages) }
steps.each { |s| all_errors.concat(s.errors.full_messages) }
[false, all_errors.uniq]
```

---

### P1-8: IngredientsController#index returns all ingredients globally

**File:** `app/controllers/ingredients_controller.rb:2-8`

**Problem:**
```ruby
def index
  matching_ingredients = Ingredient.all
  @list_of_ingredients = matching_ingredients.order({ created_at: :desc })
end
```
This returns every ingredient for every user in the system. Even after authorization is added, the scope is wrong. A user should only see ingredients belonging to their own recipes.

**Suggested solution:**
```ruby
def index
  @list_of_ingredients = current_user.recipes
    .flat_map(&:recipe_ingredients)
    .sort_by(&:created_at).reverse
end
```
Or better, if this route is not used by the UI, restrict access or remove the route from `config/routes.rb`. The same issue applies to `StepsController#index`.

---

## P2 — Polish (UX / Enhancements)

These improve user experience and project completeness.

---

### P2-1: PWA icon and service worker not verified

**File:** `app/views/layouts/application.html.erb:79`, `public/` directory

**Problem:**
The service worker is registered via `navigator.serviceWorker.register("/service-worker.js")` but the actual `service-worker.js` file in `public/` is the Rails default (empty or minimal caching worker). Verify what the service worker actually caches and whether the offline experience works.

**Suggested solution:**
Add a meaningful service worker with at least a basic cache-first strategy for the app shell, or explicitly document that the PWA is limited to installability only.

---

### P2-2: No end-to-end test plan document

**File:** `spec/` or `docs/`

**Problem:**
There is no test plan — no document listing the critical user flows that must work before a release. This is a rubric item and a professional practice gap.

**Suggested solution:**
Create `docs/test_plan.md` covering at minimum:
- User registration and sign-in/sign-out
- Upload a recipe image → verify ingredients and steps are extracted
- Edit recipe title and ingredients via the inline form (AJAX save)
- Delete a recipe
- Confirm a user cannot edit/delete another user's recipe
- Confirm a user cannot access the app without being signed in

---

### P2-3: Bullet gem is present but may not be configured

**File:** `config/environments/development.rb`

**Problem:**
`gem "bullet"` is in the Gemfile but there is no evidence that Bullet's configuration block is present in `config/environments/development.rb`. Without configuration, Bullet does not run.

**Suggested solution:**
Confirm and/or add to `config/environments/development.rb`:
```ruby
config.after_initialize do
  Bullet.enable = true
  Bullet.alert = true
  Bullet.rails_logger = true
  Bullet.add_footer = true
end
```

---

### P2-4: Recipe card shows "No Image" placeholder with low visual quality

**File:** `app/views/recipe_templates/_recipe_card.html.erb:6-9`

**Problem:**
```erb
<div class="card-img-top bg-secondary d-flex align-items-center justify-content-center text-white" style="height: 180px;">
  <span>No Image</span>
</div>
```
When a recipe has no image, the placeholder is a plain grey box with the text "No Image" — low visual quality compared to the rest of the UI's design polish.

**Suggested solution:**
Use an icon or a styled illustration placeholder, e.g., a Bootstrap icon or a simple SVG. At minimum, apply a lighter background and a camera icon:
```erb
<div class="card-img-top bg-light-lilac d-flex align-items-center justify-content-center" style="height: 180px;">
  <span class="text-muted">&#128247; No Image</span>
</div>
```

---

### P2-5: Git clone instruction uses wrong directory name in README

**File:** `README.md:39-41`

**Problem:**
```bash
git clone <repository-url>
cd recipe-parser    # actual repo name is recipe-manager, not recipe-parser
```
The `cd` command after `git clone` uses `recipe-parser` (an old name) rather than `recipe-manager`. A new developer following this guide will hit a "directory not found" error immediately.

**Suggested solution:**
Update line 41 to `cd recipe-manager` (or use the actual repository name).

---

### P2-6: CommentsController has no authorization policy

**File:** `app/controllers/comments_controller.rb`

**Problem:**
There is no `authorize` call in `CommentsController`. While the controller correctly sets `@comment.user = current_user` (preventing user spoofing), there is no Pundit policy controlling who can add comments. Currently any authenticated user can comment on any recipe or step, even those belonging to other users. Whether that is intentional behavior (public comments) should be explicitly documented; if comments are private-to-owner, a `CommentPolicy` should be created.

**Suggested solution:**
If comments should be restricted to the recipe owner:
```ruby
# app/policies/comment_policy.rb
class CommentPolicy < ApplicationPolicy
  def create?
    return false unless user.present?
    commentable = record.commentable
    commentable.respond_to?(:author_id) ? commentable.author_id == user.id : true
  end
end
```
If comments are intentionally open to all signed-in users, add a comment to the controller explaining this design decision.

---

### P2-7: Breadcrumb helper does not handle the recipe_templates controller name

**File:** `app/helpers/application_helper.rb:13-26`

**Problem:**
```ruby
case controller_name
when "recipes"
  ...
```
The `RecipesController` renders views from `recipe_templates/` via `render template: "recipe_templates/show"`, but `controller_name` is `"recipes"` — so this works correctly. However, the `when "steps"` branch references `@the_recipe.title` which is not set by the StepsController (it sets `@the_step`, not `@the_recipe`). This would silently fail to show the recipe title in the breadcrumb if a step show page is visited.

**Suggested solution:**
Fix the steps breadcrumb to use `@the_step.recipe.title` if `@the_step` is present, or ensure `@the_recipe` is set in StepsController#show.

---

### P2-8: application.html.erb has a duplicate manifest comment block

**File:** `app/assets/stylesheets/application.css:1-21`

**Problem:**
The CSS manifest file has its boilerplate comment block duplicated (lines 1-11 and lines 13-21 are identical). Minor, but suggests the file was edited carelessly.

**Suggested solution:**
Delete the duplicate comment block (lines 13-21).
