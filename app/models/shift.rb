class Shift < ApplicationRecord
  belongs_to :job

  validates :start_datetime, presence: true
  validates :end_datetime, presence: true
  validate :end_datetime_after_start_datetime

  # TODO: validate start_datetime and end_datetime so we make sure to get UTC date and time info always.

  def shift_hours
    # it could make sense to store hours on a shift on create, also if we needed to search via hours at some point.
    time_diff_seconds = (end_datetime - start_datetime)
    (time_diff_seconds / 3600.0).round(2)
  end

  def earnings
    return 0 unless job&.hourly_salary.present?
    (job.hourly_salary.to_f * shift_hours).round(2)
  end

  private

  def end_datetime_after_start_datetime
    return if end_datetime.blank? || start_datetime.blank?

    if end_datetime <= start_datetime
      errors.add(:end_datetime, "must be after start time")
    end
  end
end
