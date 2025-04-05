RSpec.describe 'API V1 Jobs API', type: :request do
  # Create a job to use in tests
  let!(:company) { create(:company) }
  let!(:jobs) { create_list(:job, 3, company: company) }
  let(:job_id) { jobs.first.id }

  path '/api/v1/jobs' do
    get 'Lists all jobs' do
      tags 'Jobs'
      produces 'application/json'

      response '200', 'jobs found' do
        schema type: :object,
          properties: {
            jobs: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  title: { type: :string },
                  hourly_salary: { type: :string },
                  created_at: { type: :string, format: :date_time },
                  updated_at: { type: :string, format: :date_time },
                  company_id: { type: :integer },
                  creator_id: { type: :integer },
                  spoken_languages: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/language' }
                  }
                }
              }
            },
            meta: {
              type: :object,
              properties: {
                total_count: { type: :integer }
              }
            }
          },
          required: [ :jobs ]

        run_test! do |response|
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['jobs'].size).to eq(3)
        end
      end
    end
  end

  path '/api/v1/jobs/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a specific job' do
      tags 'Jobs'
      produces 'application/json'

      response '200', 'job found' do
        schema({ '$ref' => '#/components/schemas/job_response' })

        let(:id) { job_id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['job']['id']).to eq(job_id)
        end
      end

      response '404', 'job not found' do
        let(:id) { 'invalid' }

        run_test! do |response|
          expect(response.status).to eq(404)
        end
      end
    end
  end
end
