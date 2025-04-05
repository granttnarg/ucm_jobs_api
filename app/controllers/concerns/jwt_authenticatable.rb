module JwtAuthenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user

    attr_reader :current_user
  end

  private

  def authenticate_user
    header = request.headers["Authorization"]
    token = header.split(" ").last if header

    begin
      payload = JwtService.decode(token)
      user_id = payload[:user_id] if payload
      @current_user = User.find(user_id)
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
