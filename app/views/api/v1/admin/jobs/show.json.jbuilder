json.job @job, partial: "api/v1/admin/jobs/job", as: :job
json.spoken_languages @job.languages, partial: "api/v1/languages/language", as: :language
json.shifts @job.shifts, partial: "api/v1/shifts/shift", as: :shift
