 json.variant do
        json.sku edit_variant.scu
        json.quantity edit_variant.quantity
        json.prices_attributes do
            svo=edit_variant.result.compare.site.site_variant_order.split(',')
            vo=edit_variant.flat.split(';')
            json.array! svo.each.with_index.to_a do  |(s,i)| 
                    json.name s
                    json.value vo[i].to_f
            end
        end
 end