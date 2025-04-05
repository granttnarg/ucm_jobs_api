class Api::V1::Admin::JobsController < Api::V1::BaseController
  before_action :require_admin
  def index
    @jobs = current_user.company.jobs
  end

  def show
    @job = current_user.company.jobs.find(params[:id])
  end

  def create
    result = Jobs::Creator.call(
      job_params: job_params,
      user: current_user,
      company: current_user.company
    )

    if result.success?
      @job = result.job
      render "api/v1/jobs/show", locals: { job: @job }, formats: [ :json ], status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def job_params
    params.require(:job).permit(:title, :hourly_salary, language_codes: [])
  end
end
