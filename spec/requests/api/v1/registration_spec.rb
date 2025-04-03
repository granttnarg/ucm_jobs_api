require 'swagger_helper'

RSpec.describe 'API V1 Registration', type: :request do
  path '/api/v1/signup' do
    post 'Creates a user' do
      tags 'Registration'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password123' },
              password_confirmation: { type: :string, example: 'password123' }
            },
            required: [ 'email', 'password', 'password_confirmation' ]
          }
        },
        required: [ 'user' ]
      }

      response '201', 'user created' do
        let(:user) { { user: { email: 'test@example.com', password: 'password123', password_confirmation: 'password123' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['message']).to eq('user created')
        end
      end

      response '422', 'invalid request' do
        let(:user) { { user: { email: 'invalid-email', password: 'short', password_confirmation: 'not-matching' } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('errors')
          expect(data['errors']).to be_an(Array)
        end
      end
    end
  end
end
