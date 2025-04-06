# README

This is a Backend Rails API designed to be digested by a Client that can work with json responses.
Jwt Authorization is integrated for certain endpoints. See the Swagger docs for more info.

## Ruby version

- 3.2.0

## Rails version

- 8.x.x

## System dependencies

- PostgreSQL (for `pg_trgm` extension)
- Redis (optional for background jobs with Sidekiq)

## Configuration

1. Clone the repository:
   `git clone https://github.com/your-username/ucm_jobs_api.git`
   `cd ucm_jobs_api`

2. Install dependencies
   `bundle install`

3. Database Creation
   `rails db:create`

4. a Database Intialization
   `rails db:migrate db:seed`
   Seeds here are for development use only.

5. b Admin Users
   Only non-admin users can be made by the api using the /signup route.
   If you want to create jobs under POST admin/jobs you must use an admin user, check seed.rb
   there is an admin user you can use setup there with default credentials

6. To Run test suite
   `bundle exec rspec`

7. Swagger file generation - optional
   `rails rswag:specs:swaggerize`
   This will recreate swagger.yaml for documentation. This is only required if you make changes to the Rswag specs or configuration.
   \*\* Also please note there is a bug with the swaggerize command. see swagger_helper.rb for more info on how this can overwrite our `bearerAuth` key and cause issues with
   the api-docs ui.

8. ENV file
   .env.copy can be set to .env. You will find the standard keys required in there.

9. Rails credentials
   ?

10. Jwt Tokens
    Tokens can be redeeded and refreshed via api/{version}/login and api/{version}/refresh for registered users. They are limited to user within 24 hours by default. JWT_EXPIRY_DEFAULT= can be set in a .env file to adjust this.

    Not the standard header format used to submit the token for locked endpoints.
    `Authorization: Bearer <token>`

    \*\*Please not the JWT Token service encryption relies on your Rails secret keybase, which should be generated and saved automatically by Rails.

11. Seeding Languages data
    `rails db:seed_european_languages`

    This will seed a subset of common european languages for development, staging or production. Tasks can be extended if you need more languages in future.
    See config/initializers/constants.rb to extend sets of language codes for use in the rake tasks.

    Rswag for Swagger-based API documentation (/api-docs)

## Deployment instructions

Currently, the application is not dockerized, but here are the general steps for deployment on a server or cloud platform:

1. **Prepare the server environment:**

   - Ensure the server has Ruby 3.2.0 and PostgreSQL installed.

2. **Deploying with Heroku (for example):**

   - Push the repository to Heroku using Git:

     ```
     git remote add heroku https://git.heroku.com/your-app.git
     git push heroku master
     ```

   - Set environment variables for the production environment (e.g., database URL, Redis URL, etc.)

   - Run migrations and seed languages the database on Heroku for Staging.
     ```bash
     heroku run rails db:migrate
     heroku run rails db:seed_european_languages
     ```

3. **Deployment with Docker (future plan):**

   - The application is currently not containerized. The plan is to create a Dockerfile and use Docker Compose to deploy the app.
   - A potential Dockerfile might look like:

     ```dockerfile
     FROM ruby:3.2.0
     WORKDIR /app
     COPY Gemfile Gemfile.lock ./
     RUN bundle install

     COPY . ./
     CMD ["rails", "server", "-b", "0.0.0.0"]
     ```

4. **CI/CD (future plan):**

   - Set up Continuous Integration and Continuous Deployment with tools like GitHub Actions, CircleCI, or GitLab CI.
