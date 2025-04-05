class Shift < ApplicationRecord
  belongs_to :job

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  def shift_hours
    # it could make sense to store hours on a shift on create, also if we needed to search via hours at some point.
    time_diff_seconds = (end_time - start_time)
    (time_diff_seconds / 3600.0).round(2)
  end

  def earnings
    return 0 unless job&.hourly_salary.present?
    (job.hourly_salary.to_f * shift_hours).round(2)
  end

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end
