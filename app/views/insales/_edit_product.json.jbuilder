json.product do
            eo = edit_offers
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
            
end