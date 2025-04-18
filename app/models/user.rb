class User < ApplicationRecord
  has_secure_password

  belongs_to :company, optional: true # Only admins can have a company
  has_many :applied_jobs, through: :job_applications, source: :job # For non admin users
  has_many :created_jobs, class_name: "Job", foreign_key: "user_id"
  validates :email, presence: true, uniqueness: true

  validate :only_admins_can_have_company

  def admin_of?(company)
    return false if company_id.nil?

    (company.id == company_id) && admin?
  end

  def only_admins_can_have_company
    if company.present? && !admin?
      errors.add(:company, "can only be assigned to admin users")
    end
  end
end
