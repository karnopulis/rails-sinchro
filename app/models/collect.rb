class Collect < ApplicationRecord
    belongs_to :offer
    belongs_to :collection
    belongs_to :compare
        
    
    def self.create_new(ori,col,of,com)

            o = Collect.new()
            o.original_id = ori
            o.offer_id = of
            o.collection_id= col
            o.compare_id =com

       return o
    end
end
