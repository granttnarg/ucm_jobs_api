FactoryBot.define do
  factory :job do
    title { "Job_title_#{rand(1000)}" }
    hourly_salary { 20 }
    association :company
    creator { association :user, admin: true, company: company }

    after(:build) do |job|
      if job.languages.empty?
        english = Language.find_or_create_by(name: 'English', code: "en-#{Time.now.to_i}")
        job.languages << english unless job.languages.include?(english)
      end

      if job.shifts.empty?
        shift = Shift.create(start_datetime: Time.current.beginning_of_hour + 1.hour, end_datetime: Time.current.beginning_of_hour + 2.hour)
        job.shifts << shift
      end
    end
  end
end
