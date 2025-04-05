json.languages @languages do |language|
  json.partial! "api/v1/languages/language", language: language
end

json.meta do
  json.total_count @languages.size
end
