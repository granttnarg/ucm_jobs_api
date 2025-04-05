require 'swagger_helper'

RSpec.describe 'API V1 Job Applications API', type: :request do
  let(:user) { create(:user) }
  let(:company) { create(:company) }
  let!(:job) { create(:job, company: company) }

  path '/api/v1/jobs/{job_id}/job_applications' do
    parameter name: :job_id, in: :path, type: :integer

    post 'Applies to a job' do
      tags 'Job Applications'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      produces 'application/json'

      response '201', 'Application submitted successfully' do
        schema type: :object,
          properties: {
            message: { type: :string, example: "Successfully applied to job. Your reference id: 123" }
          },
          required: [ 'message' ]

        let(:Authorization) { "Bearer #{generate_token_for(user)}" }
        let(:job_id) { job.id }

        before do
          mock_result = double(
            success?: true,
            job_application: double(id: 123)
          )

          allow(JobApplications::ApplyService).to receive(:call).and_return(mock_result)
        end

        run_test! do |response|
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['message']).to include("Successfully applied to job")
          expect(parsed_response['message']).to include("123")
        end
      end

      response '401', 'Not authenticated' do
        let(:Authorization) { "Bearer invalid_token" }
        let(:job_id) { job.id }
        run_test!
      end

      response '404', 'Job not found' do
        let(:Authorization) { "Bearer #{generate_token_for(user)}" }
        let(:job_id) { 999999 }

        schema type: :object,
          properties: {
            error: { type: :string, example: "Job not found" }
          },
          required: [ 'error' ]

        run_test!
      end

      response '422', 'Application could not be processed' do
        schema type: :object,
          properties: {
            error: {
              type: :array,
              items: { type: :string },
              example: [ 'You have already applied to this job' ]
            }
          },
          required: [ 'error' ]

        let(:Authorization) { "Bearer #{generate_token_for(user)}" }
        let(:job_id) { job.id }

        before do
          mock_result = double(
            success?: false,
            errors: [ 'You have already applied to this job' ]
          )

          allow(JobApplications::ApplyService).to receive(:call).and_return(mock_result)
        end

        run_test! do |response|
          expect(JSON.parse(response.body)).to have_key('error')
        end
      end
    end
  end
end
