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
      @shifts = []
    end

    def call
      ActiveRecord::Base.transaction do
        handle_languages
        handle_shifts
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
      @job.languages = @languages
      @job.shifts = @shifts

      unless @job.save
        @errors.concat(@job.errors.full_messages)
      end
    end

    def handle_languages
      language_codes = @job_params.delete(:language_codes) || []

      @languages = Language.where(code: language_codes)

      if @languages.count != language_codes.uniq.count
        missing_codes = language_codes - @languages.pluck(:code)
        @errors << "Invalid language codes: #{missing_codes.join(', ')}"
      end
    end

    def handle_shifts
      shifts_params = @job_params.delete(:shifts) || []

      if shifts_params.empty? || shifts_params.size > 7
        @errors << "Job must have between 1 and 7 shifts"
        return
      end

      shifts_params.each do |shift_param|
        shift = Shift.new(shift_param)

        # Convert times to UTC
        shift.start_datetime = shift.start_datetime.utc if shift.start_datetime
        shift.end_datetime = shift.end_datetime.utc if shift.end_datetime
        @shifts << shift
      end
    end
  end
end
