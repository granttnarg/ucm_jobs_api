FactoryBot.define do
  factory :user do
    email { "user#{rand(1000)}@example.com" }
    password { "password123" }

    factory :admin_user do
      admin { true }
    end
  end
end
