
class Api::V1::LanguagesController < ApplicationController
  skip_before_action :authenticate_user, only: [ :index ]

  def index
    @languages = Language.all.order(:name)
    render json: @languages.map { |lang| { code: lang.code, name: lang.name } }
  end
end
