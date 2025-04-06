# spec/factories/shifts.rb
FactoryBot.define do
  factory :shift do
    association :job
    start_datetime { Time.current.beginning_of_hour + 1.day }
    end_datetime { Time.current.beginning_of_hour + 1.day + 4.hours }

    trait :invalid_timespan do
      start_datetime { Time.current + 2.hours }
      end_datetime { Time.current + 1.hour }
    end
  end
end
