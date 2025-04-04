class Api::V1::JobsController < Api::V1::BaseController
  # skip_before_action :authenticate_user, only: [ :index, :show ]

  def index
    @jobs = Job.all
    render json: @jobs, status: :ok
  end

  def show
    @job = Job.find(params[:id])
    render json: @job, status: :ok
  end
end
