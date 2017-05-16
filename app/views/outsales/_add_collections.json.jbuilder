json.collections do
    json.array! new_collections do |nc|
        json.collection do
            json.sort_type 11
            json.title nc.title
            json.parent_id nc.parent_id
        end
    end
end