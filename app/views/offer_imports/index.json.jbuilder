json.array!(@offer_imports) do |offer_import|
  json.extract! offer_import, :id
  json.url offer_import_url(offer_import, format: :json)
end
