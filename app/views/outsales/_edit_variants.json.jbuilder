json.variants do
    json.array! edit_variants do |ev|
        json.id  ev.original_id
        json.sku ev.scu
        json.quantity ev.quantity
        json.prices_attributes do
            svo=ev.result.compare.site.site_variant_order.split(',')
            vo=ev.flat.split(';')
            json.array! svo.each.with_index.to_a do  |(s,i)| 
                    json.name s
                    json.value vo[i].to_f
            end
        end
    end

end