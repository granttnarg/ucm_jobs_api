# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1',
        description: <<~DESC
        ## Welcome to the UCM Jobs API

        This is a backend-only Rails API for managing jobs, users, and job_applications.

        JWT authentication is required for most endpoints. Admin role for admin endpoints

        Admin Users can not currently be made by the api. `Check Repo documentation for more info on admins`

        You can sign up normal users via `api/v1/signup`

        All Users please login via `/api/v1/login`. The return jwt token can then be used in `Authorize` or as a Bearer token.

        ---
      DESC
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ],
      components: {
        schemas: {
          job: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              total_earnings: { type: :float },
              created_at: { type: :string, format: :date_time },
              company_id: { type: :integer }
            },
            required: [ :id, :title, :total_earnings, :company_id, :created_at ]
          },

          language: {
            type: :object,
            properties: {
              name: { type: :string },
              code: { type: :string }
            },
            required: [ :name, :code ]
          },

          jobs_response: {
            type: :object,
            properties: {
              jobs: {
                type: :array,
                items: { '$ref' => '#/components/schemas/job_with_languages' }
              },
              meta: {
                type: :object,
                properties: {
                  collection_count: { type: :integer }
                }
              }
            },
            required: [ :jobs, :meta ]
          },

          job_response: {
            type: :object,
            properties: {
              job: { '$ref' => '#/components/schemas/job' },
              spoken_languages: {
                type: :array,
                items: { '$ref' => '#/components/schemas/language' }
              }
            },
            required: [ :job, :spoken_languages ]
          },

          error: {
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: { type: :string }
              }
            },
            required: [ :errors ]
          },

          job_with_languages: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              total_earnings: { type: :float },
              created_at: { type: :string, format: :date_time },
              company_id: { type: :integer },
              spoken_languages: {
                type: :array,
                items: { '$ref' => '#/components/schemas/language' }
              }
            },
            required: [ :id, :title, :total_earnings, :company_id, :created_at ]
          }
        },

        securitySchemes: {
          # NB:: In order for the swagger-ui /api-docs to work correctly `bearer_auth` needs to be switched out for `BearerAuth`, in swagger.yaml.
          # swagger.yaml is generated so these changes are lost if updated by swaggerize command.
          # Without this change the Authorization header is not sent properly and your user will appear unauthorized.
          # This is clearly a bug on how in the swaggerize command parses our schema config. Im not sure how to fix this just yet.
          # Finally bearer_auth needs to remain in this file also, otherwise our swagger specs will fail.
          bearer_auth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT
          }
        }
      },
      security: [ { bearerAuth: [] } ] # Applies globally
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
