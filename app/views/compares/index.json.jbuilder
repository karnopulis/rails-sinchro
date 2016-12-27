json.array!(@compares) do |compare|
  json.extract! compare, :id, :name, :offers, :collections
  json.url compare_url(compare, format: :json)
end
