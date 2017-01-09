class Picture < ActiveRecord::Base
    belongs_to :offer
    
#    def initialize (h)
#        new_from_hash (h)
#    end
    
    def new_from_hash_marketplace(h)
       self.url = h
       h=h.split('/')
       h=h[h.size-2]
       self.original_id = h
       return self
    end
    
    def new_from_hash_products(h)
       self.url = h["original_url"]
       self.original_id = h["id"]
       return self
    end
end