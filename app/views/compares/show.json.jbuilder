json.collections do
    new_collections=@compare.try(:result).try(:new_collections)
    new_collections=new_collections.order("collection_flat DESC") if new_collections
    json.array! new_collections do |nc|
        json.collection do
            json.extract! nc, :id, :title, :new_parent_id
        end
    end
end
json.offers do
    new_offers= @compare.try(:result).try(:new_offers)
    json.array! new_offers do |no|
         json.product do
            eo = no.try(:edit_offers).first
            json.extract! eo, :id, :scu, :title
            json.properties do
                soo=@compare.site.site_offer_order.split(',')
                oo=eo.flat.split(';')
                    soo.each.with_index { |s,i| json.set! s,oo[i] } 
            end
            json.variants do
                json.array! no.try(:edit_variants) do |ev|
                    json.extract! ev, :id,:scu,:quantity
                    svo=@compare.site.site_variant_order.split(',')
                    vo=ev.flat.split(';')
                    svo.each.with_index { |s,i| json.set! s,vo[i] }
            
                    
                end
            end    
         end
    end
end
json.collects do
    new_collects=@compare.try(:result).try(:new_collects)
    json.array! new_collects do |nc|
        json.collect do
            json.extract! nc, :id, :product_scu, :new_collection_id
        end
    end
end
json.images do
    new_pictures=@compare.try(:result).try(:new_pictures)
    new_pictures.where(:original_offer_id =>nil ) if new_pictures
    json.array! new_pictures do |np|
        json.image do
            json.extract! np, :id, :url, :scu
        end
    end
end