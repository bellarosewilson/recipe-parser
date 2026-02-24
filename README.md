# Recipe Manager

**Upload a photo or screenshot (jpg,png,heic,heif) of your recipe, Recipe Manager will parse the ingredients, units, and steps.**

---

## Table of contents

- [Setup & installation](#setup--installation)
- [Configuration](#configuration)
- [Entity relationship diagram](#entity-relationship-diagram)
- [Contributing](#contributing)
- [Troubleshooting & FAQ](#troubleshooting--faq)
- [License](#license)

---

## Setup & installation

Follow these steps so a new developer can run the project locally without external help.

### Prerequisites

- **Ruby** 3.4.1 (see [.ruby-version](.ruby-version))
- **PostgreSQL** (e.g. 14+)
- **Bundler**: `gem install bundler`

### Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd recipe-parser
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Create and load the database**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed   # if you have seed data (e.g. a default user)
   ```

4. **Configure credentials and environment** (see [Configuration](#configuration) below).

5. **Start the server**
   ```bash
   bin/rails server
   ```
   Open http://localhost:3000. Sign up or sign in, then use **Add Recipe** to upload a recipe image.

---

## Configuration

### Rails credentials

Sensitive keys are stored via Rails credentials. Edit with:

```bash
EDITOR="code --wait" bin/rails credentials:edit
```

Add (development/test can use separate credentials if needed):

- **OpenAI** (required for recipe parsing):  
  `openai_api_key: sk-your-key`
- **AWS S3** (optional for local; required for production file uploads):  
  `aws:` with `access_key_id`, `secret_access_key`, `region`, `bucket`

### Environment variables

- Use a **.env** file (loaded by `dotenv-rails`) for local overrides. Do not commit `.env`; add it to `.gitignore`.
- Optional: `OPENAI_API_KEY` if you prefer env over credentials for the key.


### Verifying OpenAI

Use the log tester script to confirm your API key and parser setup.

1. **Open the Rails console**
   ```bash
   bin/rails console
   ```

2. **Run the debug script** (paste into the console and press Enter)
   ```ruby
   load Rails.root.join("script/debug_openai_parser.rb")
   ```

3. **What the script checks**
   - **Step 1:** Whether `openai_api_key` is present in Rails credentials (and a short preview). If missing, it reminds you to run `rails credentials:edit` and add the key.
   - **Step 2:** Whether RubyLLM is configured with that key (what the app uses for parsing).
   - **Step 3:** A minimal API call (no image) — e.g. asks the model to reply "OK". If this works, the key and network are fine.
   - **Step 4:** If you have at least one recipe with an attached image, it prints a one-liner you can run to test the parser on that image; otherwise it tells you to upload a recipe first and re-run.

4. **Credentials Check** (credentials only)
   ```ruby
   Rails.application.credentials.dig(:openai_api_key).present?
   # => true
   ```
---
### Email Notification (Configuration)

Parse confirmation emails are sent after a recipe is created or re-parsed. In development, mail is logged (no SMTP). For production you need to configure delivery:

1. Set `config.action_mailer.default_url_options = { host: "your-production-host.com" }` in `config/environments/production.rb` (and use HTTPS if applicable).
2. Configure SMTP (or another delivery method): uncomment and set `config.action_mailer.smtp_settings` in production.rb, or use credentials (e.g. `smtp:` with `user_name`, `password`, `address`, `port`). Many hosts (e.g. Render, Heroku) provide SMTP add-ons or env vars for this.

**Without SMTP in production, emails will not be sent; the app will still work and jobs will enqueue.**
---

## Contributing

### Branch naming

- Use short, descriptive branches: `feature/parsing-improvements`, `fix/recipe-validation`, `docs/readme-setup`.

### Pull request process

1. Open an **issue** for non-trivial work and link it in your PR description.
2. Create a branch from `main`, make focused commits with clear messages.
3. Open a **pull request** against `main`. Describe what changed and why; reference any linked issue.
4. Request review from a maintainer or peer. Address feedback before merge.
5. Merges are done after at least one approval (or as per team policy).

### Coding conventions

- **Ruby:** Follow [Rubocop](.rubocop.yml) and `rubocop-rails-omakase`. Run `bundle exec rubocop` before pushing.
- **Rails:** Prefer skinny controllers, logic in models or service objects; use strong parameters and existing patterns (e.g. `Recipes::CreateFromImageService`).
- **Views:** Use existing layout and partials; keep ERB readable and avoid heavy logic in templates.

---

## Entity Relationship Diagram
### First Iteration
<img width="696" height="532" alt="Recipe Parser- ERD" src="https://github.com/user-attachments/assets/825d08ce-8ca3-41fb-a2e4-d94a4b64a998" />

### Final Iteration 
![alt text](image.png)

---

## Troubleshooting & FAQ

### "Parse Failing on Deployment" (e.g. No Chat GPT 4o Model / out of memory)

- **Free tier (512MB):** The app defaults to **gpt-4o-mini** for the recipe parser so it fits in Render’s free tier. Parsing should work without changes.
- **Optional:** Set env `OPENAI_PARSER_MODEL=gpt-4o-mini` on Render to make this explicit.
- **If you still hit memory limits:** Reduce upload size (images over 2MB are auto-resized before sending to OpenAI). Or move to a **paid Render plan** (e.g. Starter with more RAM) and then you can set `OPENAI_PARSER_MODEL=gpt-4o` for the full vision model. Local development is not limited by 512MB.

### "OpenAI API key not set"

- Run `bin/rails credentials:edit` and add `openai_api_key: sk-your-key`.
- Or set the key in `.env` if your setup reads it; ensure `dotenv-rails` loads `.env` in development.

### "No user in the database. Run: rails db:seed"

- The app needs at least one user to assign as recipe author. Run `bin/rails db:seed` or create a user via the sign-up page (if registration is enabled).

### Database connection errors

- Ensure PostgreSQL is running and `config/database.yml` matches your local DB name/user/password.
- For default Rails config, create the DB with `bin/rails db:create`.

### Recipe image upload fails (production)

- Configure Active Storage to use S3: set `config.active_storage.service = :amazon` (or your service name) and add AWS credentials under `aws:` in Rails credentials (or env). See [Configuration](#configuration).

### Parsed recipe has wrong units

- Users can set **preferred units** (metric/imperial) in their profile; the parser uses this when extracting amounts.

### Rubocop or tests fail in CI

- Run locally: `bundle exec rubocop` and `bundle exec rspec`. Fix any new offenses or failing specs before pushing.

---

## License

All files are covered by the MIT license. See [LICENSE.txt](LICENSE.txt).
