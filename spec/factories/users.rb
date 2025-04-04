FactoryBot.define do
  factory :user do
    email { "user#{rand(1000)}@example.com" }
    password { "password123" }

    trait :admin do
      association :company
      admin { true }
    end
  end
end
