class Price < ApplicationRecord
    belongs_to :variant
    
    def new_price (name,value,sku)
        self.title=name
        self.value=value
        self.sku=sku
        return self
    end
end
