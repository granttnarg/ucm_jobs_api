json.languages @languages do |language|
  json.partial! "api/v1/languages/language", language: language
end

json.meta do
  json.partial! "api/v1/shared/meta", collection: @languages
end
