class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job

  validate :user_not_company_admin
  validates :user_id, uniqueness: { scope: :job_id, message: "has already applied to this job" }

  private

  def user_not_company_admin
    if user&.admin_of?(job&.company)
      errors.add(:base, "Company admins cannot apply to their own company's jobs")
    end
  end
end
