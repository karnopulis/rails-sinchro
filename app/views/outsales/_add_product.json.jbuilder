
        json.product do
#                    json.category_id new_product.result.compare.category_original_id
                    eo = new_product.try(:edit_offers).first
                    json.title eo.title
                    json.sort_weight eo.sort_weight.to_f
                    json.characteristics_attributes do
                        soo=eo.result.compare.site.site_offer_order.split(',')
                        oo=eo.flat.split(';')
                            json.array! soo.each.with_index.to_a do  |(s,i)| 
                                json.title oo[i]
                                json.property_attributes do
                                     json.title s
                                end
                            end
                    end
                    json.variants_attributes do
                        json.array! new_product.try(:edit_variants) do |ev|
        #                    json.variants_attribute do
                                json.sku ev.scu
                                json.quantity ev.quantity
                                json.prices_attributes do
                                    svo=ev.result.compare.site.site_variant_order.split(',')
                                    vo=ev.flat.split(';')
                                    json.array! svo.each.with_index.to_a do  |(s,i)| 
                                        #json.prices_attribute do
                                            json.name s
                                            json.value vo[i].to_f
                                        #end
                                    end
                                end
        #                    end
                            
                        end
                    end    
        end
