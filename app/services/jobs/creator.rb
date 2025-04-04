# frozen_string_literal: true

module Jobs
  class Creator
    attr_reader :job, :errors

    def self.call(job_params:, user:, company:)
      new(job_params, user, company).call
    end

    def initialize(job_params, user, company)
      @job_params = job_params
      @user = user
      @company = company
      @errors = []
    end

    def call
      ActiveRecord::Base.transaction do
        create_job

        raise ActiveRecord::Rollback if @errors.any?
      end

      self
    end

    def success?
      @errors.empty? && @job.present?
    end

    private

    def create_job
      @job = Job.new(@job_params)
      @job.company = @company
      @job.creator = @user

      unless @job.save
        @errors.concat(@job.errors.full_messages)
      end
    end
  end
end
