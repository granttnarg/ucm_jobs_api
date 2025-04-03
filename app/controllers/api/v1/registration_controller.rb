class Api::V1::RegistrationController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      token = JwtService.encode({ user_id: @user.id })
      render json: { user: @user.as_json(except: :password_digest), token: token }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
