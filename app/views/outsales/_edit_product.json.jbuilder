json.products do
    json.array! edit_offers do |eo|
        json.product do
                    json.product_id eo.original_id
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
                    
        end
    end
end