json.collects do
    json.array! new_collects do |nc|
        json.collect do
            json.collection_id nc.collection_original_id
            json.product_id nc.product_original_id
        end
    end
 end
