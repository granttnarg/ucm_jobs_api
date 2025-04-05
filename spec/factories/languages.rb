FactoryBot.define do
  factory :language do
    code { "code_#{rand(1000)}" }
    name { "Language_name" }
  end
end
