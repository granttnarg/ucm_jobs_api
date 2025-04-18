# This File is just for data in Development.
# Please note that we have a rake seeding task for Languages on Production. see lib/tasks/seed_languages.rake

Job.destroy_all
User.destroy_all
Company.destroy_all
Shift.destroy_all
JobApplication.destroy_all

puts "All DB data destroyed"

password = ENV.fetch('ADMIN_SEED_PASSWORD', 'securepassword')
# These admin users once logged in can be used to access the routes /admin in the swagger ui /api-docs
admin = User.create!(admin: true, email: 'admin@example.com', password:, password_confirmation: password)
admin_2 = User.create!(admin: true, email: 'admin2@example.com', password:, password_confirmation: password)

applicant_user = User.create!(admin: false, email: 'applicant@example.com', password:, password_confirmation: password)

company = Company.create!(name: "Big Tech")
company_2 = Company.create!(name: "Small Tech")

admin.company = company
admin.save

admin_2.company = company_2
admin_2.save


english = Language.find_or_create_by!(name: "English-Seed", code: 'en_seed')
german = Language.find_or_create_by!(name: "German-Seed", code: 'de_seed')


languages = [ german, english ]

job1 = Job.new(title: "Senior Dev", hourly_salary: 50, company:, user_id: admin.id)
job1.languages = languages
job1.shifts.build(
  start_datetime: Time.current.beginning_of_day + 9.hours,
  end_datetime: Time.current.beginning_of_day + 17.hours
)
job1.save!

2.times do |i|
  Shift.create!(
    job: job1,
    start_datetime: Time.current.beginning_of_day + (i + 1).days + 9.hours,
    end_datetime: Time.current.beginning_of_day + (i + 1).days + 17.hours
  )
end

job2 = Job.new(title: "Jnr Dev", hourly_salary: 20, company:, user_id: admin.id)
job2.languages << german
job2.shifts.build(
  start_datetime: Time.current.beginning_of_day + 9.hours,
  end_datetime: Time.current.beginning_of_day + 17.hours
)
job2.save!

2.times do |i|
  Shift.create!(
    job: job2,
    start_datetime: Time.current.beginning_of_day + (i + 1).days + 9.hours,
    end_datetime: Time.current.beginning_of_day + (i + 1).days + 17.hours
  )
end

job3 = Job.new(title: "HR Manager", hourly_salary: 25.50, company: company_2, user_id: admin_2.id)
job3.languages << german
job3.shifts.build(
  start_datetime: Time.current.beginning_of_day + 9.hours,
  end_datetime: Time.current.beginning_of_day + 17.hours
)
job3.save!

2.times do |i|
  Shift.create!(
    job: job3,
    start_datetime: Time.current.beginning_of_day + (i + 1).days + 9.hours,
    end_datetime: Time.current.beginning_of_day + (i + 1).days + 17.hours
  )
end

JobApplication.create!(user: applicant_user, job: job1, status: "pending")
JobApplication.create!(user: applicant_user, job: job2, status: "rejected")

puts "Seeds Created"
