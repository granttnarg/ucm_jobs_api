require 'swagger_helper'

RSpec.describe 'API V1 Jobs API', type: :request do
  let!(:company) { create(:company) }
  let!(:jobs) { create_list(:job, 3, company: company) }
  let(:job_id) { jobs.first.id }

  path '/api/v1/jobs' do
    get 'Lists all jobs' do
      tags 'Jobs'
      produces 'application/json'

      response '200', 'jobs found' do
        schema '$ref' => '#/components/schemas/jobs_response'

        run_test! do |response|
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['jobs'].size).to eq(3)
          expect(parsed_response['jobs'].first['spoken_languages']).to be_present
          expect(parsed_response['jobs'].first['shifts_count']).to be_present
          expect(parsed_response['jobs'].first['total_earnings']).to be_present
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

  path '/api/v1/jobs/search' do
    get 'Searches for jobs with filters' do
      tags 'Jobs'
      produces 'application/json'

      parameter name: :title, in: :query, type: :string, required: false,
                description: 'Filter jobs by title (partial match)'
      parameter name: :language_codes, in: :query, type: :array,
                items: { type: :string },
                collectionFormat: :multi,
                required: false,
                description: 'Filter jobs by language codes'

      response '200', 'search results found' do
        schema '$ref' => '#/components/schemas/jobs_response'

        context 'with valid parameters' do
          let(:title) { 'Engineer' }

          run_test! do |response|
            parsed_response = JSON.parse(response.body)
            expect(response.status).to eq(200)
            expect(parsed_response).to have_key('jobs')
            expect(parsed_response).to have_key('meta')
            expect(parsed_response['jobs']).to be_an(Array)
          end
        end

        context 'with language filter' do
          let(:language_codes) { [ 'en' ] }
          let(:title) { Job.last.title }

          run_test! do |response|
            parsed_response = JSON.parse(response.body)
            expect(parsed_response['jobs']).to be_an(Array)
            expect(parsed_response['jobs'].first['title']).to eq(title)
          end
        end
      end
    end
  end
end
