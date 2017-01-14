class Price < ApplicationRecord
    belongs_to :variant
    
    
    def new_price (name,value)
        self.title=name
        self.value=value
        return self
    end
end
