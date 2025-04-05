FactoryBot.define do
  factory :job do
    title { "Job_title_#{rand(1000)}" }
    hourly_salary { 9.90 }
    association :company
    creator { association :user, admin: true, company: company }
  end
end
