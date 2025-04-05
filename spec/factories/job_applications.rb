FactoryBot.define do
  factory :job_application do
    association :user
    association :job
    status { "Pending" }
  end
end
