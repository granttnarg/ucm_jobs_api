# README

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

4. Database Intialization
   `rails db:migrate db:seed`

5. To Run test suite
   `bundle exec rspec`

6. Swagger file generation
   `rails rswag:specs:swaggerize`
   This will recreate swagger.yaml for documentation

Rswag for Swagger-based API documentation (/api-docs)

7. Deployment Instructions
   ??
