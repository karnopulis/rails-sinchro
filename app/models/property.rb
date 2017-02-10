class Property < ApplicationRecord
    belongs_to :compare
    has_many :characteristics, dependent: :delete_all
    has_many :offers, :through => :characteristics
    
    
    def new_from_hash (h)
       self.original_id = h["id"].to_i
       self.title = h["title"]
       return self
    end
end
