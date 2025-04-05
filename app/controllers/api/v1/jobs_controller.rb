class Api::V1::JobsController < Api::V1::BaseController
  skip_before_action :authenticate_user, only: [ :index, :show, :search ]

  def initialize
    super
    @job_searcher = Jobs::Search::Service
  end

  def index
    @jobs = Job.includes(:languages, :shifts).order(created_at: :desc).limit(10)
  end

  def show
    @job = Job.includes(:languages, :shifts).find(params[:id])
  end

  def search
    @jobs = @job_searcher.search(search_params)
  end

  private

  def search_params
    params.permit(:title, language_codes: [],)
  end
end
