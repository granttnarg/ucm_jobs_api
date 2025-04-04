FactoryBot.define do
  factory :job_application do
    user { nil }
    job { nil }
    status { "MyString" }
  end
end
