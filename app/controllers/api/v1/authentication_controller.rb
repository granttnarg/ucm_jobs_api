class Api::V1::AuthenticationController < ApplicationController
  def create
    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = JwtService.encode({ user_id: @user.id })
      # expires_at could be useful to return, depending how this is being used.
      render json: { user: @user.as_json(except: :password_digest), token: token }, status: :ok
    else
      render json: { error: "Invalid User Credentials" }, status: :unauthorized
    end
  end

  def refresh
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    begin
      decoded = JwtService.decode(token)
      user = User.find(decoded&.dig(:user_id))

      new_token = JwtService.encode(user_id: user.id)
      render json: { token: new_token }
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end
end
