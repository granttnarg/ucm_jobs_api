# spec/factories/shifts.rb
FactoryBot.define do
  factory :shift do
    association :job
    start_time { Time.current.beginning_of_hour + 1.day }
    end_time { Time.current.beginning_of_hour + 1.day + 4.hours }

    trait :invalid_timespan do
      start_time { Time.current + 2.hours }
      end_time { Time.current + 1.hour }
    end
  end
end
