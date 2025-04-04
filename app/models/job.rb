class Job < ApplicationRecord
  belongs_to :company
  has_many :job_applications, dependent: :destroy
  has_many :applicants, through: :job_applications, source: :user # non-admin users who applied

  validates :title, presence: true
  validates :hourly_salary, numericality: { greater_than: 0 }
end
