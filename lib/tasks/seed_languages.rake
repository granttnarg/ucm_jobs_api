require "iso-639"

namespace :db do
  desc "Seed common European languages"
  task seed_european_languages: :environment do
    count = 0

    AppConstants::Languages::EUROPEAN_CODES.each do |code|
      language = ISO_639.find_by_code(code)
      next unless language

      Language.find_or_create_by(code: code) do |lang|
        lang.name = language.english_name
        count += 1
        puts "Created language: #{lang.name} (#{lang.code})"
      end
    end

    puts "Seeded #{count} European languages"
  end
end
