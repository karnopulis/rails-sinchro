json.images do
    json.array! new_images do |ni|
        json.image do
            json.src ni.url
            json.position ni.position
            json.size ni.size

            json.product_id ni.original_offer_id
        end
    end
end