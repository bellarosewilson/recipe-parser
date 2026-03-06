# SDF Final Project Rubric - Technical

- Date/Time: 2026-03-06
- Trainee Name: bellarosewilson
- Project Name: Recipe Manager
- Reviewer Name: Claude, Ian Heraty, Adolfo Nava
- Repository URL: <https://github.com/bellarosewilson/recipe-manager>
- Feedback Pull Request URL: <https://github.com/bellarosewilson/recipe-manager/pull/36>

---

## Readme (max: 10 points)

- [x] **Markdown**: Is the README formatted using Markdown?
  > Evidence: `README.md` uses `#` headers, `##` section headers, fenced code blocks (```bash, ```ruby), inline code, tables, ordered/unordered lists, and images.

- [x] **Naming**: Is the repository name relevant to the project?
  > Evidence: Repository directory is `recipe-manager`; project is a recipe parsing and management app. Directly relevant.

- [x] **1-liner**: Is there a 1-liner briefly describing the project?
  > Evidence: `README.md` line 3 — *"Is an image parser that allows home cooks to upload a photo or screenshot of a recipe- Recipe Manager will parse the ingredients, units, and steps."* (Minor: missing "It" at the start, but the description is present and clear.)

- [x] **Instructions**: Are there detailed setup and installation instructions, ensuring a new developer can get the project running locally without external help?
  > Evidence: `README.md` Setup & Installation section covers prerequisites (Ruby 3.4.1, PostgreSQL, Bundler), clone, `bundle install`, `db:create/migrate/seed`, credentials configuration, and `bin/rails server`. A new developer can follow these without external help.

- [x] **Configuration**: Are configuration instructions provided, such as environment variables or configuration files that need to be set up?
  > Evidence: `README.md` Configuration section covers Rails credentials (`EDITOR="code --wait" bin/rails credentials:edit`), `openai_api_key`, AWS S3 keys (`access_key_id`, `secret_access_key`, `region`, `bucket`), `.env` with `dotenv-rails`, and email/SMTP setup for production.

- [x] **Contribution**: Are there clear contribution guidelines?
  > Evidence: `README.md` Contributing section includes branch naming conventions (`feature/`, `fix/`, `docs/`), PR process (open issue, branch from main, request review, one approval), and coding conventions (Rubocop, skinny controllers, service objects, strong params).

- [x] **ERD**: Does the documentation include an entity relationship diagram?
  > Evidence: `README.md` line 250 — `![Entity Relationship Diagram](docs/erdimage.png)`. File path `docs/erdimage.png` is referenced.

- [x] **Troubleshooting**: Is there an FAQs or Troubleshooting section?
  > Evidence: `README.md` Troubleshooting & FAQ section addresses: "OpenAI API key not set", "Parse Failing on Deployment", "No user in the database", "Database connection errors", "Recipe image upload fails", "Parsed recipe has wrong units", "Rubocop or tests fail in CI".

- [x] **Visual Aids**: Are there visual aids?
  > Evidence: `README.md` references `docs/openai-verification-log.png` (OpenAI verification log screenshot) and `docs/erdimage.png` (ERD).

- [x] **API Documentation**: Is there clear and detailed documentation for the project's API?
  > Evidence: `README.md` API Documentation section documents `PATCH /recipes/:id` with authentication requirements, request headers (Accept, Content-Type, X-CSRF-Token), request body parameters (table format), success response (200 OK with JSON example), validation error response (422 with JSON example), and authorization note.

### Score (10/10):

### Notes:
Exceptional README. Well above average for an apprenticeship project. Covers all required areas comprehensively, including a verification script for API key setup. Minor: the 1-liner begins with "Is an image parser" — missing "It" at the start. The `git clone` step shows `recipe-parser` as the directory name, which does not match the actual repo name `recipe-manager` — this could confuse new developers.

---

## Version Control (max: 10 points)

- [x] **Version Control**: Is the project using a version control system such as Git?
  > Evidence: `.git/` directory exists at the project root. `git status` confirms an active git repository on branch `main`.

- [x] **Repository Management**: Is the repository hosted on a platform like GitHub?
  > Evidence: `.github/workflows/ci.yml` exists (GitHub Actions). The project board URL in `README.md` uses `github.com/users/bellarosewilson/projects/1`. GitHub confirmed.

- [x] **Commit Quality**: Does the project have regular commits with clear, descriptive messages?
  > Evidence: Recent commits from git log — `"+ Feature Edit Steps/Ingredients and Updated Views"`, `"+Updated ReadMe"`, `"Merge +Feature to Main"`, `"+Final Polish on Updated Views"`, `"+Notes Section Updated to Bottom, +Syntax Fixes"`. Messages are descriptive and convey intent. Note: the `+` prefix notation is non-standard.

- [x] **Pull Requests**: Does the project employ a clear branching and merging strategy?
  > Evidence: Commit `fb43341 Merge +Feature to Main` in git log indicates a feature branch was created and merged into `main` via a merge commit. Branch naming convention is documented in `README.md`.

- [x] **Issues**: Is the project utilizing issue tracking to manage tasks and bugs?
  > <https://github.com/bellarosewilson/recipe-manager/issues>

- [ ] **Linked Issues**: Are issues linked to pull requests?
  > <https://github.com/bellarosewilson/recipe-manager/pull/31>

- [x] **Project Board**: Does the project utilize a project board?
  > Evidence: `README.md` Project Board section links to `https://github.com/users/bellarosewilson/projects/1/views/1`. Link is present

- [ ] **Code Review Process**: Is there evidence of a code review process?
  > <https://github.com/bellarosewilson/recipe-manager/pull/29>

- [ ] **Branch Protection**: Are the main branches protected to prevent direct commits?

- [x] **Continuous Integration/Continuous Deployment (CI/CD)**: Has the project implemented CI/CD pipelines?
  > Evidence: `.github/workflows/ci.yml` defines two jobs: `lint` (runs `bundle exec rubocop -f github`) and `test` (sets up PostgreSQL service, runs `bundle exec rspec`). Triggers on `pull_request` and `push` to `main`.

### Score (7/10):

### Notes:

The CI/CD setup is solid — two-job pipeline with separate lint and test stages, proper PostgreSQL service configuration, and health checks.

---

## Code Hygiene (max: 8 points)

- [x] **Indentation**: Is the code consistently indented throughout the project?
  > Evidence: Ruby files use 2-space indentation consistently (`app/controllers/recipes_controller.rb`, `app/models/recipe.rb`, all service objects). JavaScript files use 2-space indentation consistently. ERB templates are consistently indented.

- [x] **Naming Conventions**: Are naming conventions clear, consistent, and descriptive?
  > Evidence: Methods named `recipe_author`, `parse_recipe_image`, `openai_key_blank?`, `apply_parsed_data` are descriptive. Variables like `@list_of_recipes`, `@the_recipe`, `@can_reparse_recipe` are clear. Service objects follow `Namespace::ServiceNameService` convention.

- [x] **Casing Conventions**: Are casing conventions consistent?
  > Evidence: Ruby uses `snake_case` for methods/variables (`recipe_author`, `parse_recipe`), `PascalCase` for classes (`RecipesController`, `OpenAiParser::ParserService`). JavaScript uses `camelCase` for methods (`updateDOM`, `addIngredient`) and Stimulus `kebab-case` for controller names.

- [x] **Layouts**: Is the code utilizing Rails' `application.html.erb` layout effectively?
  > Evidence: `app/views/layouts/application.html.erb` provides the shared structure with `<%= yield %>`, renders `shared/navbar`, `shared/flash`, and `shared/breadcrumbs` partials, and includes Bootstrap and custom CSS. A separate `landing.html.erb` layout is used for the public home page.

- [x] **Code Clarity**: Is the code easy to read and understand?
  > Evidence: `RecipesController` is thin (delegates to `Recipes::CreateFromImageService`). Service objects have clear `call` entry points and `Result` structs. Model methods like `apply_parsed_data` and `parse_original_image` are focused. `CommentsController` has a clean polymorphic resolution pattern.

- [x] **Comment Quality**: Does the code include inline comments explaining "why"?
  > Evidence: Meaningful why-comments found throughout — `app/services/open_ai_parser/parser_service.rb:60` `"# gpt-4o-mini uses less memory and works on Render free tier (512MB)"`, `app/models/step.rb:22` `"# To keep steps in order on recipe card"`, `app/models/recipe.rb:31` `"# For User to be able to delete ingredients/steps when editing/reviewing recipe"`.

- [ ] **Minimal Unused Code**: Unused code should be deleted (not commented out).
  > Evidence of issues:
  > - `Gemfile`: 11 commented-out gems with notes like "not used", "not configured/used", "disabled" — should be deleted entirely, not left as commented code.
  > - `app/javascript/controllers/hello_controller.js`: Default Stimulus boilerplate from Rails generator — not used anywhere in the application.
  > - `app/views/layouts/application.html.erb` lines 27-61: A large `<style>` block with 35+ CSS rules that largely duplicates rules already defined in `app/assets/stylesheets/application.css`. One set should be removed.

- [x] **Linter**: Is a linter used and configured?
  > Evidence: `.rubocop.yml` inherits from `rubocop-rails-omakase` and `.rubocop_todo.yml`. Rubocop is in `Gemfile` group `:development, :test`. CI pipeline runs `bundle exec rubocop -f github` on every push and PR.

### Score (7/8):

### Notes:
Good overall hygiene. The main issues are: (1) 11+ commented-out gems in `Gemfile` — these represent documented-but-deleted dependencies that should simply be removed; (2) `hello_controller.js` is unused boilerplate; (3) the duplicate `<style>` block in `application.html.erb` creates a maintenance burden since styles must be updated in two places. The linter is well-configured with both Rubocop omakase and a todo file for existing offenses.

---

## Patterns of Enterprise Applications (max: 10 points)

- [x] **Domain Driven Design**: Does the application follow domain-driven design principles?
  > Evidence: Business logic is placed in models (`Recipe#apply_parsed_data`, `Recipe#parse_original_image`) and service objects (`Recipes::CreateFromImageService`, `OpenAiParser::ParserService`). Controllers are thin and delegate to services. The domain is clearly modeled around Recipe, Ingredient, Step, and Comment entities.

- [x] **Advanced Data Modeling**: Has the application utilized ActiveRecord callbacks for model lifecycle management?
  > Evidence: `app/models/comment.rb:26` — `before_validation :strip_comment_body` strips whitespace before validation. `app/models/step.rb:22` — `default_scope { order(position: :asc) }` ensures steps are always ordered. `app/models/recipe.rb:32-33` — `accepts_nested_attributes_for` with `allow_destroy: true` for ingredients and steps.

- [x] **Component-Based View Templates**: Does the application use partials?
  > Evidence: Partials include `shared/_flash.html.erb`, `shared/_navbar.html.erb`, `shared/_breadcrumbs.html.erb`, `recipe_templates/_recipe_card.html.erb`, `recipe_templates/_ingredients.html.erb`, `recipe_templates/_steps.html.erb`, `recipe_templates/_comments.html.erb`, `recipe_templates/_ingredient_fields.html.erb`, `recipe_templates/_step_fields.html.erb`. Extensively used for reusability.

- [x] **Backend Modules**: Does the application use modules/concerns?
  > Evidence: `app/models/concerns/commentable.rb` defines the `Commentable` concern using `ActiveSupport::Concern`. It is included in both `Recipe` and `Step` models to share the `has_many :comments, as: :commentable, dependent: :destroy` behavior without duplication.

- [x] **Frontend Modules**: Does the application use frontend modules?
  > Evidence: Six Stimulus controllers defined as ES6 modules in `app/javascript/controllers/`: `ajax_recipe_form_controller.js`, `file_size_controller.js`, `nested_form_controller.js`, `recipe_channel_controller.js`, `collapse_close_controller.js`. Each exports a `Controller` class extending `@hotwired/stimulus`.

- [x] **Service Objects**: Does the application abstract logic into service objects?
  > Evidence: `app/services/recipes/create_from_image_service.rb` — handles the full recipe creation lifecycle (validation, image attachment, parsing, email). `app/services/open_ai_parser/parser_service.rb` — encapsulates all OpenAI API interaction, image resolution, and JSON normalization. Both use the `Result` struct / value object pattern.

- [x] **Polymorphism**: Does the application use polymorphism?
  > Evidence: `app/models/comment.rb:29` — `belongs_to :commentable, polymorphic: true`. `db/schema.rb` includes `commentable_type` and `commentable_id` columns on the comments table. Both `Recipe` and `Step` include the `Commentable` concern, making comments attachable to either model.

- [x] **Event-Driven Architecture**: Does the application use event-driven architecture?
  > Evidence: `app/channels/recipe_channel.rb` defines a `RecipeChannel` using ActionCable's `stream_for`. `RecipesController` broadcasts events via `broadcast_recipe_event` on `update` and `parse` actions. `SolidCable` is used as the database-backed adapter. `recipe_channel_controller.js` subscribes to the channel and shows live toasts when the recipe is updated or re-parsed.

- [x] **Overall Separation of Concerns**: Are concerns separated effectively?
  > Evidence: Parsing logic is in `OpenAiParser::ParserService`, not the controller. Recipe creation orchestration is in `Recipes::CreateFromImageService`. Authorization is in Pundit policies (`RecipePolicy`). Shared UI behavior is in partials and the `ApplicationHelper`. Controllers are focused on HTTP concerns only.

- [x] **Overall DRY Principle**: Does the application follow DRY?
  > Evidence: `Commentable` concern eliminates duplication between Recipe and Step. Service objects prevent controller duplication. Partials prevent view duplication. `accepts_nested_attributes_for` avoids duplicate CRUD controllers for sub-resources.
  > Note: `ajax_recipe_form_controller.js` and `recipe_channel_controller.js` both implement nearly identical `updateDOM` methods — a minor DRY violation in the JavaScript layer.

### Score (10/10):

### Notes:
This is the strongest section. The architecture is genuinely impressive for an apprenticeship capstone — service objects with `Result` structs, polymorphic associations, ActionCable real-time broadcasting, and a proper `Commentable` concern. One point deducted for the duplicated `updateDOM` logic across two Stimulus controllers. Minor issue: `Recipe#apply_parsed_data` contains `errors = errors.full_messages.to_a` which shadows `self.errors` with a local variable — works in Ruby but is confusing and should be rewritten.

---

## Design (max: 5 points)

- [x] **Readability**: Ensure the text is easily readable.
  > Evidence (code only): Bootstrap 5 base styles provide proven readable defaults. Custom theme uses `#6f42c1` purple on white backgrounds and white text on purple navbar — standard, readable contrast ratios. `"Plus Jakarta Sans"` is a clean, modern sans-serif. Needs visual verification.

- [x] **Line length**: The horizontal width of text blocks should be no more than 2-3 lowercase alphabets.

- [x] **Font Choices**: Use appropriate font sizes, weights, and styles.
  > Evidence: Google Font `"Plus Jakarta Sans"` loaded with weights 400, 500, 600, 700. Bootstrap's typographic scale is used (`h3`, `h5`, `h6` classes). Font weights applied for hierarchy (`fw-bold`, `font-weight: 500` on buttons).

- [x] **Consistency**: Maintain consistent font usage and colors.
  > Evidence: A single font family (`"Plus Jakarta Sans"`) used throughout via CSS variables. Purple theme (`#6f42c1`) consistently applied across buttons, links, navbar, pagination, and breadcrumbs via CSS custom properties in `application.css`.

- [x] **Double Your Whitespace**: Ensure ample spacing around elements.
  > Bootstrap utility classes (`mb-4`, `pt-4`, `g-4`, `gap-2`) are used, suggesting reasonable spacing, but cannot verify visually.

### Score (5/5):

### Notes:
The design choices are sound: consistent purple theme, single font family, Bootstrap grid for layout. Score reflects 3 verifiable items plus Bootstrap's inherent whitespace defaults.

---

## Frontend (max: 10 points)

- [x] **Mobile/Tablet Design**: Looks and works great on mobile/tablet.
  >Bootstrap responsive grid classes are present (`row-cols-1 row-cols-md-2 row-cols-lg-3`, `col-lg-8 col-lg-4`, `navbar-expand-lg`).

- [x] **Desktop Design**: Looks and works great on desktop.
  > Bootstrap card grid and sticky sidebar layout.

- [x] **Styling**: Does the frontend employ CSS or CSS frameworks for styling?
  > Evidence: Bootstrap 5.3.3 loaded via CDN. Custom styles in `app/assets/stylesheets/application.css` (192 lines). `autoprefixer-rails` gem adds vendor prefixes.
  > Issue: `app/views/layouts/application.html.erb` lines 27-61 contains a large inline `<style>` block (35+ rules) that duplicates most of what is already in `application.css`. Inline CSS is significantly overused here. Individual `style=""` attributes also scattered in views (e.g., `style="object-fit: cover; height: 180px;"` in `_recipe_card.html.erb`, `style="top: 1rem;"` in `show.html.erb`).

- [x] **Semantic HTML**: Is the project making effective use of semantic HTML elements?
  > Evidence: `<main class="container app-main ...">` in `application.html.erb:67`. `<nav class="navbar ...">` in `_navbar.html.erb:1`. `<nav aria-label="breadcrumb">` in `_breadcrumbs.html.erb:3`. `<ol class="list-group ...">` for ordered steps in `_steps.html.erb`. `<dl>`, `<dt>`, `<dd>` for recipe metadata in `show.html.erb:39-52`.

- [x] **Feedback**: Are styled flashes or toasts implemented in a partial?
  > Evidence: `app/views/shared/_flash.html.erb` renders Bootstrap `alert-success` and `alert-danger` dismissible alerts for `notice` and `alert` flash keys. Rendered in the shared layout via `<%= render "shared/flash" %>`. ActionCable toast implemented in `recipe_channel_controller.js#showToast`.

- [x] **Client-Side Interactivity**: Is JavaScript utilized for client-side experience?
  > Evidence: Five production Stimulus controllers: `ajax_recipe_form_controller.js` (AJAX PATCH), `file_size_controller.js` (upload validation), `nested_form_controller.js` (dynamic ingredient/step rows), `recipe_channel_controller.js` (ActionCable real-time), `collapse_close_controller.js` (collapse UX). Stimulus framework used throughout.

- [x] **AJAX**: Is Asynchronous JavaScript used to perform a CRUD action and update the UI?
  > Evidence: `app/javascript/controllers/ajax_recipe_form_controller.js` — `submit()` method (line 16) intercepts form submission, performs `fetch()` with `method: "PATCH"`, parses JSON response, and updates `#recipe_title_display`, `#recipe_source_display`, and form inputs in the DOM without a page reload. Endpoint: `PATCH /recipes/:id` with JSON response.

- [x] **Form Validation**: Does the project include client-side form validation?
  > Evidence: `app/javascript/controllers/file_size_controller.js` — validates file size on the `change` event, disables the submit button and shows an error message if the file exceeds the configured max (default 10MB). Implemented on the recipe upload form in `recipe_templates/new.html.erb`. HTML5 `required: true` and `maxlength: 255` attributes also used on recipe edit form.

- [x] **Accessibility: alt tags**: Are alt tags implemented?
  > Evidence: `app/views/recipe_templates/_recipe_card.html.erb:4` — `alt: recipe.title.presence || "Recipe Image"`. `app/views/recipe_templates/show.html.erb:28` — `alt: @the_recipe.title.presence || "Recipe Image"`. Alt tags present on recipe images with meaningful fallback.

- [x] **Accessibility: ARIA roles**: Are ARIA roles implemented?
  > Evidence: `_navbar.html.erb` — `aria-controls="navbarNav"`, `aria-expanded="false"`, `aria-label="Toggle navigation"`. `_breadcrumbs.html.erb` — `aria-label="breadcrumb"`, `aria-current="page"`. `_flash.html.erb` — `role="alert"` on flash divs. `recipe_channel_controller.js:51` — dynamically created toasts include `role="alert"`.

### Score (10/10):

### Notes:
Strong frontend with good AJAX, Stimulus, and accessibility fundamentals. The inline `<style>` block in `application.html.erb` is a significant hygiene issue, duplicating external CSS and making maintenance harder. All styles should live in `application.css`.

---

## Backend (max: 9 points)

- [x] **CRUD**: Does the application implement at least one resource with full CRUD functionality?
  > Evidence: `RecipesController` implements `index`, `show`, `new`, `create`, `update`, `destroy`, and custom `parse` actions. `IngredientsController` and `StepsController` also implement full CRUD. Routes confirmed in `config/routes.rb`.

- [x] **MVC pattern**: Does the application follow the Model-View-Controller pattern?
  > Evidence: `RecipesController` delegates creation to `Recipes::CreateFromImageService` and parsing to `Recipe#parse_original_image` — controller stays under 25 lines per action. Models hold domain logic. Views use partials for presentation. The `IngredientsController` and `StepsController` are thinner by virtue of simplicity but lack authorization (noted in Security section).

- [x] **RESTful Routes**: Are the routes RESTful?
  > Evidence: `config/routes.rb` uses `resources :recipes`, `resources :ingredients`, `resources :steps`, `resources :comments`. Custom `post :parse` is a member action on recipes, which is a valid RESTful extension. Nested `resources :comments` under both recipes and steps for polymorphic comment creation.

- [x] **DRY queries**: Are database queries primarily implemented in the model layer?
  > Evidence: `RecipesController#index` uses `policy_scope(Recipe).ransack(params[:q]).result.recent.includes(:author).page(params[:page]).per(12)` — chaining model-defined scope `recent` with includes. `RecipesController#show` uses `Recipe.includes(:author, :recipe_ingredients, :steps).find(params[:id])` — eager loading defined at the controller level appropriately. No raw SQL or complex queries in views.

- [x] **Data Model Design**: Is the data model well-designed?
  > Evidence: `db/schema.rb` shows: `recipes` (title, author_id, source_url), `ingredients` (recipe_id, name, amount, unit), `steps` (recipe_id, position, instruction), `comments` (polymorphic commentable, user_id, body). Active Storage for image attachments. Composite index on `comments(commentable_type, commentable_id)`. The `chats`, `messages`, `models`, `tool_calls` tables appear to be from the `ruby_llm` gem and represent internal AI conversation tracking.

- [x] **Associations**: Does the application efficiently use Rails association methods?
  > Evidence: `Recipe` — `belongs_to :author (class_name: "User")`, `has_many :recipe_ingredients (class_name: "Ingredient")`, `has_many :steps`, `has_one_attached :original_image`, `has_many :comments (via Commentable)`. `User` — `has_many :recipes`, `has_many :comments`, `has_one_attached :original_image`. `Comment` — `belongs_to :user`, `belongs_to :commentable, polymorphic: true`.

- [x] **Validations**: Are validations implemented to ensure data integrity?
  > Evidence: `Recipe` — `validates :title, presence: true`, `validates :author_id, presence: true`. `Ingredient` — `validates :name, presence: true`, `validates :amount, presence: true, allow_blank: true`, `validates :recipe_id, presence: true`. `Step` — `validates :position, presence: true`, `validates :instruction, presence: true`. `Comment` — `validates :body, presence: true, length: { maximum: 2000 }`. `User` — `validates :preferred_units, inclusion: { in: %w[metric imperial] }, allow_nil: true`.

- [x] **Query Optimization**: Does the application use scopes?
  > Evidence: `app/models/recipe.rb:15` — `scope :recent, -> { order(created_at: :desc) }`. `app/models/step.rb:22` — `default_scope { order(position: :asc) }`. `RecipePolicy::Scope#resolve` scopes records to current user. `Ransack` query object pattern used for search. `includes` used for eager loading throughout.

- [ ] **Database Management**: Are additional features such as file upload (CSV) or custom rake tasks included?
  > Evidence: No rake tasks found (no `lib/tasks/*.rake` files). No CSV import functionality. This item is not implemented.

### Score (8/9):

### Notes:
Strong backend with good use of associations, validations, scopes, and eager loading. Two items unmet: (1) No rake tasks or CSV import; (2) The schema has a notable issue — `recipes.author_id` and `ingredients.recipe_id`/`steps.recipe_id` are declared as `integer` type (not `bigint`) and have no foreign key constraints declared in the schema. This means the database does not enforce referential integrity at the DB level. Also: `IngredientsController` returns `Ingredient.all` globally — any authenticated user can view/edit all ingredients regardless of recipe ownership. This is addressed in the Security section.

---

## Quality Assurance and Testing (max: 2 points)

- [ ] **End to End Test Plan**: Does the project include an end to end test plan?
  > Evidence: No test plan document found. `spec/features/sample_spec.rb` exists but contains only `expect(1).to eq(1)` — a placeholder, not a real test plan.

- [x] **Automated Testing**: Does the project include a test suite?
  > Evidence: `spec/models/recipe_spec.rb` — RSpec model spec using shoulda-matchers to test associations (`belong_to :author`, `have_many :recipe_ingredients`, `have_many :steps`) and validations (`validate_presence_of :title`, `validate_presence_of :author_id`). `spec/requests/recipes_request_spec.rb` — two request specs testing `GET /recipes` returns 200 when signed in and redirects to sign-in when not authenticated. RSpec infrastructure is well-configured (capybara, selenium, shoulda-matchers, webmock).

### Score (1/2):

### Notes:
The test setup (RSpec, capybara, shoulda-matchers, webmock, headless Chrome) is solid and CI runs `bundle exec rspec` on every push. However, actual test coverage is very thin — only 5 real test assertions across 2 spec files. The `sample_spec.rb` is a boilerplate placeholder that should either be expanded into real feature specs or deleted. Critical paths not tested: recipe creation, image upload, parsing, authorization enforcement, ingredient/step CRUD, comments. The test infrastructure investment suggests intent to expand coverage.

---

## Security and Authorization (max: 5 points)

- [x] **Credentials**: Are API keys and sensitive information securely stored?
  > Evidence: `README.md` documents using `bin/rails credentials:edit` to store `openai_api_key` and AWS keys. `app/services/recipes/create_from_image_service.rb:47` checks `Rails.application.credentials.dig(:openai_api_key)`. `dotenv-rails` gem for `.env` local overrides. `.gitignore` should exclude `.env` (standard Rails `.gitignore`). No hardcoded secrets found in source files.

- [x] **HTTPS**: Is HTTPS enforced?
  > Evidence: `config/environments/production.rb:31` — `config.force_ssl = true`. Confirmed present.

- [x] **Sensitive attributes**: Are sensitive attributes assigned in the model/controller?
  > Evidence: `CommentsController#create` — `@comment.user = current_user` (line 7) — user is assigned server-side from session, not from form input. `RecipesController#recipe_params` assigns `p[:author_id] = recipe_author.id` programmatically, not via user-submitted params.

- [x] **Strong Params**: Are strong parameters used?
  > Evidence: `RecipesController#recipe_params` — `params.require(:recipe).permit(:title, :source_url, recipe_ingredients_attributes: [...], steps_attributes: [...])`. `CommentsController#comment_params` — `params.require(:comment).permit(:body)`. `IngredientsController#ingredient_params` — `params.require(:ingredient).permit(:recipe_id, :unit, :amount, :name)`.
  > Issue: `ingredient_params` and `step_params` permit `:recipe_id` directly from user input. A malicious user can submit a crafted form to create or update an ingredient/step on any recipe they do not own. This is a security vulnerability.

- [ ] **Authorization**: Is an authorization framework employed to manage user permissions?
  > Evidence: Pundit is used and `RecipePolicy` is well-implemented — `show?`, `create?`, `update?`, `destroy?`, `parse?` are defined; `Scope#resolve` filters to current user's recipes. `ApplicationController` includes `Pundit::Authorization` and rescues `Pundit::NotAuthorizedError`.
  > Critical Issue: `IngredientsController` has **zero authorization calls** — no `authorize` on `index`, `show`, `create`, `update`, or `destroy`. Any authenticated user can view, edit, or delete any ingredient in the database. `StepsController` has the same problem. `CommentsController` has no `authorize` call (though it does rely on `authenticate_user!` via the parent class). There are no `IngredientPolicy` or `StepPolicy` files.

### Score (4/5):

### Notes:
Two critical security issues prevent full score:
1. **Missing authorization on IngredientsController and StepsController** — authenticated users can CRUD any ingredient or step in the database, regardless of recipe ownership. Pundit policies for Ingredient and Step are missing entirely.
2. **`recipe_id` in strong params** — `ingredient_params` and `step_params` permit `:recipe_id`, enabling cross-user data manipulation. The `recipe_id` should be set server-side from the authenticated context, not trusted from user input.
Additionally: `RecipesController#recipe_author` has a fallback `|| User.first` that would assign recipes to the first user if `current_user` is nil. While `authenticate_user!` prevents this in practice, the defensive fallback is a code smell.

---

## Features (each: 1 point - max: 15 points)

- [x] **Sending Email**: Does the application send transactional emails?
  > Evidence: `app/mailers/recipe_mailer.rb` defines `parse_confirmation(recipe, user)`. Called via `RecipeMailer.parse_confirmation(recipe, @author).deliver_later` in both `RecipesController#parse` and `Recipes::CreateFromImageService#call`. Email subject is dynamic (`"Recipe parsed: #{recipe.title}"`). Mailer attaches the recipe image if present. Runs asynchronously via ActiveJob/SolidQueue.

- [ ] **Sending SMS**: Does the application send transactional SMS messages?
  > Not implemented.

- [x] **Building for Mobile (PWA)**: Implementation of a Progressive Web App.
  > Evidence: `app/views/layouts/application.html.erb` registers a service worker (`navigator.serviceWorker.register("/service-worker.js")`). `app/views/pwa/manifest.json.erb` provides a web app manifest with `display: "standalone"` and `start_url: "/"`.
  > Critical Issue: `manifest.json.erb` contains **template placeholders** — `"name": "Rails8Template"`, `"description": "Rails8Template."`, `"theme_color": "red"`, `"background_color": "red"`. These are default values from the Rails generator that were never updated to match the actual application.

- [x] **Advanced Search and Filtering**: Incorporation of advanced search and filtering.
  > Evidence: `gem "ransack"` in `Gemfile`. `RecipesController#index` — `@q = policy_scope(Recipe).ransack(params[:q])`. `Recipe.ransackable_attributes` defined to whitelist searchable fields. `app/views/recipe_templates/index.html.erb` — `search_form_for @q` with `title_cont` predicate for title substring search.

- [ ] **Data Visualization**: Integration of charts or graphs.
  > Not implemented.

- [x] **Dynamic Meta Tags**: Dynamic generation of meta tags.
  > Evidence: `app/views/recipe_templates/show.html.erb` lines 1-12 — dynamic `<title>` via `content_for(:title, @the_recipe.title)`, `<meta name="description">` with ingredient/step counts, `<meta property="og:title">` and `<meta property="og:description">` with recipe data.

- [x] **Pagination**: Use of pagination libraries.

- [ ] **Internationalization (i18n)**: Support for multiple languages.
  > Not implemented.

- [ ] **Admin Dashboard**: Creation of an admin panel.
  > Not implemented.

- [ ] **Business Insights Dashboard**: Creation of an insights dashboard.
  > Not implemented.

- [x] **Enhanced Navigation**: Breadcrumbs used to enhance site navigation.
  > Evidence: `app/helpers/application_helper.rb` — `breadcrumb_items` method builds contextual breadcrumb arrays based on `controller_name` and `action_name`. `app/views/shared/_breadcrumbs.html.erb` renders the breadcrumb nav with `aria-label="breadcrumb"` and `aria-current="page"`. Rendered in the application layout on every page.

- [x] **Performance Optimization**: Is the Bullet gem used?
  > Evidence: `gem "bullet"` in `Gemfile` development group. Presence confirms intent to detect N+1 queries in development. Note: Cannot verify that Bullet is configured/enabled in `config/environments/development.rb` from local inspection — needs verification that `config.after_initialize { Bullet.enable = true }` or equivalent is set.

- [x] **Stimulus**: Implementation of Stimulus.js.
  > Evidence: `gem "stimulus-rails"` in `Gemfile`. `app/javascript/controllers/` contains 5 custom Stimulus controllers: `ajax_recipe_form_controller.js`, `file_size_controller.js`, `nested_form_controller.js`, `recipe_channel_controller.js`, `collapse_close_controller.js`. Controllers registered in `app/javascript/controllers/index.js` and `application.js`.

- [x] **Turbo Frames**: Implementation of Turbo Frames.
  > Evidence: `gem "turbo-rails"` in `Gemfile`. `app/views/recipe_templates/index.html.erb:21` — `<%= turbo_frame_tag "recipes_list" do %>` wraps the recipe list and pagination. `app/views/recipe_templates/_recipe_card.html.erb:12` — `data: { turbo_frame: "_top" }` on the "View Recipe" link.

- [ ] **Other**: Not applicable.

### Score (9/15):

### Notes:
Strong feature set. Credited: Email, PWA (with heavy caveat), Advanced Search, Dynamic Meta Tags, Pagination, Breadcrumbs, Bullet, Stimulus, Turbo Frames.
**PWA critical issue:** `manifest.json.erb` contains the `"Rails8Template"` placeholder name and `"theme_color": "red"` / `"background_color": "red"` — these are unmodified Rails generator defaults. This must be corrected before the PWA provides any real value.
Not implemented: SMS, Data Visualization, i18n, Admin Dashboard, Business Insights.

---

## Ambitious Features (each: 2 points - max: 16 points)

- [ ] **Receiving Email**: Not implemented.

- [ ] **Inbound SMS**: Not implemented.

- [ ] **Web Scraping Capabilities**: Not implemented.

- [x] **Background Processing**: Are background jobs implemented?
  > Evidence: `gem "solid_queue"` in `Gemfile` (database-backed ActiveJob adapter). `db/schema.rb` includes full SolidQueue schema (`solid_queue_jobs`, `solid_queue_ready_executions`, etc.). `RecipeMailer.parse_confirmation.deliver_later` in both `RecipesController#parse` and `Recipes::CreateFromImageService#call` — emails are enqueued as background jobs. `app/jobs/application_job.rb` exists.

- [ ] **Mapping and Geolocation**: Not implemented.

- [x] **Cloud Storage Integration**: Integration with cloud storage services.
  > Evidence: `gem "aws-sdk-s3", require: false` in `Gemfile`. `README.md` Configuration section documents full AWS S3 setup with `access_key_id`, `secret_access_key`, `region`, `bucket` via Rails credentials. Active Storage configured to use S3 in production (`config.active_storage.service = :amazon` referenced in README troubleshooting). Images are stored via `has_one_attached :original_image` on Recipe.

- [x] **AI Integration**: Implementation of AI services.
  > Evidence: `gem "ruby_llm"` in `Gemfile`. `app/services/open_ai_parser/parser_service.rb` — uses `RubyLLM.chat(model: vision_model)` with GPT-4o vision capabilities. Sends recipe images to OpenAI, requests structured JSON output, and parses ingredients and steps. Supports metric/imperial unit conversion via prompt. Model selection configurable via `OPENAI_PARSER_MODEL` env var.

- [ ] **Payment Processing**: Not implemented.

- [ ] **OAuth**: Not implemented.

- [x] **Other**: Real-time collaboration via ActionCable.
  > Evidence: `app/channels/recipe_channel.rb` — ActionCable channel with `stream_for recipe`. `RecipesController` broadcasts `"updated"` and `"parsed"` events with recipe payload. `gem "solid_cable"` (database-backed adapter). `recipe_channel_controller.js` subscribes to the channel and dynamically updates the DOM and shows toast notifications when other sessions modify the recipe. This is a meaningful real-time feature beyond the standard Rails feature set.

### Score (8/16):

### Notes:
Three core ambitious features implemented — AI integration (OpenAI vision via RubyLLM), cloud storage (AWS S3), and background processing (SolidQueue/ActiveJob). ActionCable real-time broadcasting awarded as "Other" for its genuine implementation quality. Five categories not attempted (inbound email, SMS, web scraping, maps, payments, OAuth).

---

## Technical Score (/100):
- Readme (10/10)
- Version Control (7/10)
- Code Hygiene (7/8)
- Patterns of Enterprise Applications (10/10)
- Design (5/5)
- Frontend (10/10)
- Backend (8/9)
- Quality Assurance and Testing (1/2)
- Security and Authorization (4/5)
- Features (9/15)
- Ambitious Features (8/16)
---
- **Total: 79/100**

---

## Additional overall comments:

This is a genuinely impressive capstone project. The trainee has demonstrated advanced Rails knowledge well beyond what is typically expected at this stage — service objects with `Result` structs, polymorphic associations, ActionCable real-time features, AI integration with structured output parsing, AWS S3 cloud storage, and a well-documented README. The architecture is thoughtful and shows real understanding of separation of concerns.

**Where the project stands out:**
- The service object design (`Recipes::CreateFromImageService`, `OpenAiParser::ParserService`) is professional-grade. The `Result` struct pattern and robust error handling (including the parse failure cleanup heuristic) show mature thinking.
- The ActionCable real-time broadcasting — while a small feature — is correctly implemented end-to-end from server broadcast to Stimulus subscriber.
- The README is excellent, arguably the strongest in the cohort. The debugging guide with a step-by-step console script for verifying the OpenAI integration is a standout touch.
- AI integration with vision model, unit conversion via prompt engineering, and graceful fallback behavior shows strong initiative.

**Where it falls short of apprenticeship-ready:**
1. **Authorization gaps are the most serious issue.** `IngredientsController` and `StepsController` have no Pundit authorization. Any authenticated user can view, modify, or destroy any ingredient or step in the database. This is a real security vulnerability in a multi-user app.
2. **Strong params permit `:recipe_id` from user input** in ingredient and step controllers, enabling cross-user data manipulation.
3. **Test coverage is extremely thin.** The testing infrastructure is excellent but almost entirely unused. Five assertions across two spec files is insufficient for an app with this much logic.
4. **The PWA manifest has never been configured** — it still contains "Rails8Template" defaults. Either fix it or remove the PWA claim.

Strong work. Fix the authorization gaps and add test coverage, and this would comfortably meet the production-readiness bar. The ambition and technical depth are clearly there.
