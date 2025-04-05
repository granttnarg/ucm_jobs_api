json.jobs @jobs do |job|
  json.partial! "api/v1/jobs/job", job: job
  json.spoken_languages job.languages, partial: "api/v1/languages/language", as: :language
  json.shifts_count job.shifts.count
end

json.meta do
  json.total_count @jobs.size
end
