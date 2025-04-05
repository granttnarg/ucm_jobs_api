FactoryBot.define do
  factory :job_application do
    user { nil }
    job { nil }
    status { "Pending" }
  end
end
