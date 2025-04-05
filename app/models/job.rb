class Job < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :company
  has_many :job_applications, dependent: :destroy
  has_many :applicants, through: :job_applications, source: :user # non-admin users who applied

  validates :title, presence: true
  validates :hourly_salary, numericality: { greater_than: 0 }
  validate :creator_must_be_company_admin

  def creator_must_be_company_admin
    if creator.present? && (!creator.admin? || creator.company_id != company_id)
      errors.add(:creator, "must be an admin of this company")
    end
  end
end
