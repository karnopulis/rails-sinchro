json.image do
            json.original_url new_image.url
            json.position new_image.position
            json.size new_image.size
            json.product_id new_image.original_offer_id
end