FactoryBot.define do
  factory :company do
    name { "Company_name_#{rand(1000)}" }
  end
end
