class Price < ApplicationRecord
    belongs_to :variant
    
    def new_price (name,value,sku)
        self.title=name
#        puts value
#        puts value.class
        self.value=value.to_s.to_f
        self.sku=sku
        return self
    end
end
