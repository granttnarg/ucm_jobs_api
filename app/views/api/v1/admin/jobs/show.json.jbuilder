json.job @job, partial: "api/v1/jobs/job", as: :job
json.spoken_languages @job.languages, partial: "api/v1/languages/language", as: :language
