json.array!(@offers) do |offer|
  json.extract! offer, :id, :scu, :title, :original_id
  json.url offer_url(offer, format: :json)
end
