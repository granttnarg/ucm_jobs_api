FactoryBot.define do
  factory :job do
    title { "Job_title_#{rand(1000)}" }
    hourly_salary { 9.90 }
    association :company
    creator { association :user, admin: true, company: company }

    after(:build) do |job|
      if job.languages.empty?
        english = Language.find_or_create_by(name: 'English', code: "en-#{Time.now.to_i}")
        job.languages << english unless job.languages.include?(english)
      end
    end
  end
end
