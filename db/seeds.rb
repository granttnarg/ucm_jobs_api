# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Job.destroy_all
User.destroy_all
Company.destroy_all

puts "All DB data destroyed"

password = ENV.fetch('ADMIN_SEED_PASSWORD', 'securepassword')
admin = User.create!(admin: true, email: 'test@example', password:, password_confirmation: password)
applicant_user = User.create!(admin: false, email: 'hello@example', password:, password_confirmation: password)

company = Company.create!(name: "Big Tech")

admin.company = company
admin.save

languages = [ Language.find_or_create_by!(name: "English", code: 'en'), Language.find_or_create_by!(name: "German", code: 'de') ]

Job.create!(title: "Senior Dev", hourly_salary: 50, company:, user_id: admin.id, languages:)
Job.create!(title: "Jnr Dev", hourly_salary: 1, company:, user_id: admin.id, languages:)

puts "Seeds Created"
