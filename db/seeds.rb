# This File is just for data in Development.
# Please note that we have a rake seeding task for Languages on Production. see lib/tasks/seed_languages.rake

Job.destroy_all
User.destroy_all
Company.destroy_all
Shift.destroy_all
JobApplication.destroy_all

puts "All DB data destroyed"

password = ENV.fetch('ADMIN_SEED_PASSWORD', 'securepassword')
admin = User.create!(admin: true, email: 'test@example', password:, password_confirmation: password)
applicant_user = User.create!(admin: false, email: 'hello@example', password:, password_confirmation: password)

company = Company.create!(name: "Big Tech")

admin.company = company
admin.save

languages = [
  Language.find_or_create_by!(name: "English-Seed", code: 'en_seed'),
  Language.find_or_create_by!(name: "German-Seed", code: 'de_seed')
]


job1 = Job.new(title: "Senior Dev", hourly_salary: 50, company:, user_id: admin.id)
job1.languages = languages
job1.shifts.build(
  start_time: Time.current.beginning_of_day + 9.hours,
  end_time: Time.current.beginning_of_day + 17.hours
)
job1.save!

2.times do |i|
  Shift.create!(
    job: job1,
    start_time: Time.current.beginning_of_day + (i + 1).days + 9.hours,
    end_time: Time.current.beginning_of_day + (i + 1).days + 17.hours
  )
end

job2 = Job.new(title: "Jnr Dev", hourly_salary: 1, company:, user_id: admin.id)
job2.languages = languages
job2.shifts.build(
  start_time: Time.current.beginning_of_day + 9.hours,
  end_time: Time.current.beginning_of_day + 17.hours
)
job2.save!

2.times do |i|
  Shift.create!(
    job: job2,
    start_time: Time.current.beginning_of_day + (i + 1).days + 9.hours,
    end_time: Time.current.beginning_of_day + (i + 1).days + 17.hours
  )
end

JobApplication.create!(user: applicant_user, job: job1, status: "pending")
JobApplication.create!(user: applicant_user, job: job2, status: "rejected")

puts "Seeds Created"
