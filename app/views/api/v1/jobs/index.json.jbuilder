json.jobs @jobs do |job|
  json.partial! "api/v1/jobs/job", job: job
  json.spoken_languages job.languages, partial: "api/v1/languages/language", as: :language
  json.shifts_count job.shifts.count
  json.total_earnings job.total_earnings
end

json.meta do
  json.partial! "api/v1/shared/meta", collection: @jobs
end
