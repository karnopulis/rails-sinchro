json.variants do
    json.array! edit_variants do |ev|
                    json.id ev.original_id
#                    json.sku ev.scu
                    json.quantity ev.quantity
                    svo=ev.result.compare.site.site_variant_order.split(',')
                    vo=ev.flat.split(';')
                    svo.each.with_index { |s,i| json.set! s,vo[i] }
            
                    
                end
    

end