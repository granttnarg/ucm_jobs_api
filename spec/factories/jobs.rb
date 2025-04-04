FactoryBot.define do
  factory :job do
    title { "MyString" }
    hourly_salary { "9.99" }
    association :company
    association :creator, factory: :admin_user
  end
end
