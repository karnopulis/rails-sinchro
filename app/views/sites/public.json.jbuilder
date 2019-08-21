json.array!(@sites) do |site|
  json.extract! site, :name, :address
end
