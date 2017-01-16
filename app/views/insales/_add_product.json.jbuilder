json.product do
            eo = new_offers.try(:edit_offers).first
            json.title eo.title
            json.sort_weight = eo.sort_weight
            json.properties_attributes do
                soo=eo.result.compare.site.site_offer_order.split(',')
                oo=eo.flat.split(';')
                    soo.each.with_index do  |s,i| 
                        json.properties_attribute do
                            json.set! s,oo[i]  
                        end
                    end
            end
            json.variants_attributes do
                json.array! no.try(:edit_variants) do |ev|
                    json.variants_attribute do
                        json.scu ev.scu
                        json.quantity ev.quantity
                        svo=ev.result.compare.site.site_variant_order.split(',')
                        vo=ev.flat.split(';')
                        svo.each.with_index { |s,i| json.set! s,vo[i] }
                    end
                    
                end
            end    
end