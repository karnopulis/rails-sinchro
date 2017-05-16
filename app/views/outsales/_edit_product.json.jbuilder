
        json.product do
                    json.title edit_product.title
                    json.sort_weight edit_product.sort_weight.to_f
                    json.characteristics_attributes do
                        soo=edit_product.result.compare.site.site_offer_order.split(',')
                        oo=edit_product.flat.split(';')
                            json.array! soo.each.with_index.to_a do  |(s,i)| 
                                json.title oo[i]
                                json.property_attributes do
                                     json.title s
                                end
                            end
                    end
                    
        end
