json.array!(@collect_imports) do |collect_import|
  json.extract! collect_import, :id
  json.url collect_import_url(collect_import, format: :json)
end
