json.collection do
    puts new_collection.class
    json.sort_type 10
    json.title new_collection.title
    json.parent_id new_collection.parent_id
end