require 'swagger_helper'

RSpec.describe 'API V1 Admin Jobs API', type: :request do
  let!(:admin_user) { create(:user, :admin) }
  let(:non_admin_user) { create(:user) }

  path '/api/v1/admin/jobs' do
    get 'Lists all jobs for the company' do
      tags 'Admin Jobs'
      security [ bearer_auth: [] ]

      response '200', 'Jobs retrieved successfully' do
        schema type: :array, items: { '$ref' => '#/components/schemas/job' }

        let(:Authorization) { "Bearer #{generate_token_for(admin_user)}" }

        run_test! do |response|
          expect(JSON.parse(response.body).length).to eq(admin_user.company.jobs.count)
        end
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { "Bearer invalid_token" }
        run_test!
      end

      response '403', 'Not authorized (not an admin)' do
        let(:Authorization) { "Bearer #{generate_token_for(non_admin_user)}" }
        run_test!
      end
    end

    post 'Creates a new job' do
      tags 'Admin Jobs'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :job, in: :body, schema: {
        type: :object,
        properties: {
          job: {
            type: :object,
            properties: {
              title: { type: :string, example: 'Software Engineer' },
              hourly_salary: { type: :number, format: :float, example: 35.50 }
            },
            required: [ :title, :hourly_salary ]
          }
        },
        required: [ :job ]
      }

      response '201', 'Job created successfully' do
        schema '$ref' => '#/components/schemas/job'

        let(:Authorization) { "Bearer #{generate_token_for(admin_user)}" }
        let(:job) { { job: { title: 'Software Engineer', hourly_salary: 35.50 } } }

        run_test! do |response|
          expect(JSON.parse(response.body)['title']).to eq('Software Engineer')
        end
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { "Bearer invalid_token" }
        let(:job) { { job: { title: 'Software Engineer', hourly_salary: 35.50 } } }
        run_test!
      end

      response '403', 'Not authorized (not an admin)' do
        let(:Authorization) { "Bearer #{generate_token_for(non_admin_user)}" }
        let(:job) { { job: { title: 'Software Engineer', hourly_salary: 35.50 } } }
        run_test!
      end

      response '422', 'Invalid request' do
        schema '$ref' => '#/components/schemas/error'


        let(:Authorization) { "Bearer #{generate_token_for(admin_user)}" }
        let(:job) { { job: { title: '', hourly_salary: -5 } } }

        run_test! do |response|
          expect(JSON.parse(response.body)).to have_key('errors')
        end
      end
    end
  end

  path '/api/v1/admin/jobs/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a specific job' do
      tags 'Admin Jobs'
      security [ bearer_auth: [] ]
      produces 'application/json'

      response '200', 'Job found' do
        schema '$ref' => '#/components/schemas/job'

        let!(:admin_user) { create(:user, :admin) }
        let(:Authorization) { "Bearer #{generate_token_for(admin_user)}" }
        let!(:job) { create(:job, company: admin_user.company) }
        let(:id) { admin_user.company.jobs.first.id }

        run_test! do |response|
          expect(JSON.parse(response.body)['id']).to eq(id)
        end
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { "Bearer invalid_token" }
        let(:id) { 1 }
        run_test!
      end

      response '403', 'Not authorized (not an admin)' do
        let(:Authorization) { "Bearer #{generate_token_for(non_admin_user)}" }
        let(:id) { 1 }
        run_test!
      end

      response '404', 'Job not found' do
        let(:Authorization) { "Bearer #{generate_token_for(admin_user)}" }
        let(:id) { 999999 }
        run_test!
      end
    end
  end
end
