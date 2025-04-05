class Language < ApplicationRecord
  has_and_belongs_to_many :jobs

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
