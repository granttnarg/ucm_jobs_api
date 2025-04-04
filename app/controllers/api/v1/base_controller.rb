module Api
  module V1
    class BaseController < ApplicationController
      include JwtAuthenticatable
      include Authorization

      before_action :authenticate_user
    end
  end
end
