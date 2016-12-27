class Collect < ActiveRecord::Base
    belongs_to :offer
    belongs_to :collection
    belongs_to :compare
        
    
        def new_from_hash (h)
        oo=[]
        h.each { |a| 
            o = Collect.new()
            o.original_id = a["id"].to_i
            offer_id = a["product_id"].to_i
            collection_id= a["collection_id"].to_i

        }
       return oo
    end
end
