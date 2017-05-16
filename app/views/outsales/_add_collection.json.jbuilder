 json.collection do
            json.sort 1
            json.title new_collection.title
            json.parent new_collection.parent_id
            json.position new_collection.position
        end