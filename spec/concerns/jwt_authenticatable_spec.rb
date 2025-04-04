require 'rails_helper'

RSpec.describe JwtAuthenticatable, type: :controller do
  controller(ApplicationController) do
    include JwtAuthenticatable

    def index
      render json: { message: 'succesful request' }
    end
  end

  # Set up routes for the test controller
  before do
    routes.draw { get 'index' => 'anonymous#index' }
  end

  let(:user) { create(:user) }
  let(:token) { JwtService.encode(user_id: user.id) }

  describe '#authenticate_user' do
    context 'with valid token' do
      it 'sets current_user and allows access' do
        request.headers['Authorization'] = "Bearer #{token}"
        get :index

        expect(response).to have_http_status(:ok)
        expect(controller.current_user).to eq(user)
        expect(JSON.parse(response.body)['message']).to eq('succesful request')
      end
    end

    context 'with invalid token' do
      it 'returns unauthorized when token is invalid' do
        request.headers['Authorization'] = 'Bearer invalid_token'
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end

      it 'returns unauthorized when token is missing' do
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end

      it 'returns unauthorized when user is not found' do
        # Create token with non-existent user ID
        invalid_token = JwtService.encode(user_id: 999999)
        request.headers['Authorization'] = "Bearer #{invalid_token}"
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end

    context 'with bad header' do
      it 'returns unauthorized when Authorization header is not the right format' do
        request.headers['Authorization'] = 'Malformatted'
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Unauthorized')
      end
    end
  end
end
