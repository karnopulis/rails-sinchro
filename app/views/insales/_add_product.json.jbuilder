json.product do
            json.category_id new_offer.result.compare.category_original_id
            eo = new_offer.try(:edit_offers).first
            json.title eo.title
            json.sort_weight eo.sort_weight.to_f
            json.properties_attributes do
                soo=eo.result.compare.site.site_offer_order.split(',')
                oo=eo.flat.split(';')
                    json.array! soo.each.with_index.to_a do  |(s,i)| 
#                        json.properties_attribute do
#                            json.set! s,oo[i]  
                             json.title s
                             json.value oo[i]
#                        end
                    end
            end
            json.variants_attributes do
                json.array! new_offer.try(:edit_variants) do |ev|
#                    json.variants_attribute do
                        json.sku ev.scu
                        json.quantity ev.quantity
                        svo=ev.result.compare.site.site_variant_order.split(',')
                        vo=ev.flat.split(';')
                        svo.each.with_index { |s,i| json.set! s,vo[i] }
#                    end
                    
                end
            end    
end