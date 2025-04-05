class Job < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :company
  has_and_belongs_to_many :languages
  has_many :job_applications, dependent: :destroy
  has_many :applicants, through: :job_applications, source: :user # non-admin users who applied
  has_many :shifts, dependent: :destroy

  validates :title, presence: true
  validates :hourly_salary, numericality: { greater_than: 0 }

  validate :creator_must_be_company_admin

  validate :must_have_at_least_one_language

  validates :shifts, length: { minimum: 1, message: "at least one shift is required" }
  validate :maximum_seven_shifts

  def total_earnings
    shifts.sum { |shift| shift.earnings }
  end

  private

  def creator_must_be_company_admin
    if creator.present? && (!creator.admin? || creator.company_id != company_id)
      errors.add(:creator, "must be an admin of this company")
    end
  end

  def must_have_at_least_one_language
    errors.add(:languages, "must have at least one language") if languages.empty?
  end

  def maximum_seven_shifts
    if shifts.size > 7
      errors.add(:shifts, "maximum of 7 shifts allowed")
    end
  end
end
