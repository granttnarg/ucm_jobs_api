require 'rails_helper'

RSpec.describe Authorization, type: :controller do
  controller(ApplicationController) do
    include JwtAuthenticatable
    include Authorization

    before_action :require_admin, only: :admin_action
    skip_before_action :authenticate_user

    def admin_action
      render json: { success: true }
    end
  end

  before do
    routes.draw { get 'admin_action' => 'anonymous#admin_action' }
  end

  let(:admin_user) { create(:user, :admin) }
  let(:regular_user) { create(:user) }

  describe '#require_admin' do
    it 'allows admin users' do
      allow(controller).to receive(:current_user).and_return(admin_user)
      get :admin_action
      expect(response).to have_http_status(:ok)
    end

    it 'denies non-admin users' do
      allow(controller).to receive(:current_user).and_return(regular_user)
      get :admin_action
      expect(response).to have_http_status(:forbidden)
    end

    it 'denies unauthenticated requests' do
      allow(controller).to receive(:current_user).and_return(nil)
      get :admin_action
      expect(response).to have_http_status(:forbidden)
    end
  end
end
