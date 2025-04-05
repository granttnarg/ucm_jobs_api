
class Api::V1::LanguagesController < Api::V1::BaseController
  skip_before_action :authenticate_user, only: [ :index ]

  def index
    @languages = Language.all.order(:name)
  end
end
