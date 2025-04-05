class Api::V1::JobApplicationsController < Api::V1::BaseController
  before_action :authenticate_user
  before_action :set_job

  def create
    result = JobApplications::ApplyService.call(
      user: current_user,
      job: @job
    )
    if result.success?
      render json: {
        message: "Successfully applied to job. Your reference id: #{result.job_application.id}"
      }, status: :created
    else
      render json: { error: result.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Job not found" }, status: :not_found
  end
end
