json.array!(@sites) do |site|
  json.extract! site, :id, :name, :url, :site_login, :site_pass, :home_login, :home_pass, :site_global_parent, :csv_collection_order, :csv_variant_order, :site_variant_order, :csv_offer_order, :site_offer_order, :sort_order, :scu_field, :quantity_field, :title_field, :csv_images_order
  json.url site_url(site, format: :json)
end
