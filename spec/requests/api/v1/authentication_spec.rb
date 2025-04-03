require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/api/v1/login' do
    post 'Authenticates user and returns JWT token' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }

      response '200', 'user authenticated' do
        let(:user) { create(:user, email: 'test@example.com', password: 'password123', password_confirmation: "password123") }
        let(:credentials) { { email: user.email, password: 'password123' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('token')
          expect(data).to have_key('user')
          expect(data['user']).to have_key('email')
          expect(data['user']).not_to have_key('password_digest')
        end
      end

      response '401', 'invalid credentials' do
        let(:credentials) { { email: 'wrong@example.com', password: 'wrongpassword' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('error')
          expect(data['error']).to eq('Invalid User Credentials')
        end
      end
    end
  end

  path '/api/v1/refresh' do
    post 'Refreshes JWT token' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      security [ bearer_auth: [] ]

      parameter name: :Authorization, in: :header, type: :string,
                description: 'Bearer token from login', required: true

      response '200', 'token refreshed' do
        let(:user) { create(:user) }
        let(:token) { JwtService.encode(user_id: user.id) }
        let(:Authorization) { "Bearer #{token}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('token')

          # Verify the token is valid and contains expected payload
          new_token = data['token']
          decoded = JwtService.decode(new_token)
          expect(decoded).to have_key(:user_id)
          expect(decoded[:user_id]).to eq(user.id)
        end
      end

      response '401', 'invalid token' do
        let(:Authorization) { "Bearer invalid.token.here" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data).to have_key('error')
          expect(data['error']).to eq('Invalid token')
        end
      end
    end
  end
end
