# README

This is a backend-only Ruby on Rails API (v8.x) designed for JSON clients. It supports JWT-based authentication and is documented via Swagger (Rswag/Open API 3).

> 🚧 MVP – WIP in development, planned improvements include Docker and CI/CD

# Features

- User Signup
- JWT Authentication (with refresh flow)
- Role-based authorization (admin vs regular users)
- Job / JobApplication create and listings
- Shift and Language support with seedable data
- PostgreSQL with pg_trgm for fuzzy search (planned)
- RSpec test suite
- Swagger/OpenAPI 3 docs (via RSwag)

## Ruby version

- 3.2.x

## Rails version

- 8.x.x (API-only mode)

## System dependencies

- PostgreSQL (for `pg_trgm` extension)

## Configuration

1. Clone the repository:
   `git clone https://github.com/your-username/ucm_jobs_api.git`
   `cd ucm_jobs_api`

2. Install dependencies
   `bundle install`

3. ENV file
   `cp env.example .env`
   env.example can be set to .env. You will find the standard keys required in there.
   Set your RAILS_MASTER_KEY using the contents of config/master.key. This is required to decrypt Rails credentials.

4. Rails credentials
   `EDITOR="code --wait" bin/rails credentials:edit`
   You can store secrets like JWT_SECRET here. If not set, the app will fall back to the Rails.application.secret_key_base.

   Generate a secure base64 secret with for your JWT_SECRET:
   `openssl rand -base64 64`

   ```
   developement:
         jwt_secret: <your-base64-code>
   ```

5. Database Creation
   `rails db:create`

6. Database Initalization

   `rails db:migrate db:seed`
   Seeds here are for development use only.

   `rails db:seed_european_languages` - seeds additional common European languages (recommended for staging/production)

7. Admin Users
   Only non-admin users can be made by the api using the /signup route.
   If you want to create jobs under POST admin/jobs you must use an admin user, check seed.rb
   there is an admin user you can use setup there with default credentials

8. To Run test suite
   `bundle exec rspec`

9. Swagger file generation - optional
   ⚠️ Note: This command can overwrite the bearerAuth key in swagger_helper.rb, causing issues with JWT auth in /api-docs. A workaround is documented in the helper file.

   `rails rswag:specs:swaggerize`
   This will recreate swagger.yaml for documentation. This is only required if you make changes to the Rswag specs or configuration.

10. Run Rails Server
    `bundle exec rails s`

    defaults to localhost:3000/api/v1

11. API Documentation
    Swagger UI is available for testing our api at:
    `/api-docs`

    Uses RSwag for request specs and documentation generation.

12. Jwt Tokens

    Login: POST /api/v1/login

    Token Refresh: POST /api/v1/refresh

    Tokens expire after 24 hours by default. You can configure this via: JWT_EXPIRY_DEFAULT= in your .env file

    Header Format:
    `Authorization: Bearer <token>`

    \*\* User must be signed up before they can retrive a jwt token.

## Deployment instructions

Heroku (MVP Stage)

1. Add remote:
   `git remote add heroku https://git.heroku.com/<REPO>.git`

2. Push to Heroku:
   `git push heroku main`

3. On Heroku, run:
   `heroku run rails db:migrate`
   `heroku run rails db:seed_european_languages`

4. Admin User will need to be made mainly on the console. See the seed.rb for how this works.

Docker (Planned)
Rails 8 includes a basic Docker setup scaffold, but it hasn't been customized yet. Docker support is planned for improved consistency across dev environments.

CI/CD (Planned)
A basic CI pipeline (GitHub Actions) will:

- Run tests on PRs

- Require approvals before merging

- Enable automated deployments on merge
