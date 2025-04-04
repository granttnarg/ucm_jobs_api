class Company < ApplicationRecord
  has_many :users  # Only admin users are linked to companies
  has_many :jobs, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
