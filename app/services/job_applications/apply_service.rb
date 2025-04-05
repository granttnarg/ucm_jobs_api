module JobApplications
  class ApplyService
    attr_reader :job_application, :errors

    def self.call(user:, job:)
      new(user, job).call
    end

    def initialize(user, job)
      @user = user
      @job = job
      @job_application = nil
      @errors = []
    end

    def call
      return self unless valid_application?
      create_application

      self
    end

    def success?
      @errors.empty? && @job_application.present?
    end

    private

    def valid_application?
      return true unless already_applied?

      @errors << "You have already applied to this job"
      false
    end

    def already_applied?
      JobApplication.exists?(user: @user, job: @job)
    end

    def create_application
      ActiveRecord::Base.transaction do
        @job_application = JobApplication.new(
          user: @user,
          job: @job
        )

        unless @job_application.save
          @errors = @job_application.errors.full_messages
          @job_application = nil
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end
