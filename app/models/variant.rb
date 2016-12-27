class Variant < ActiveRecord::Base
    belongs_to :offer
    has_many :prices
    
    
    def new_from_hash (v)
       self.sku = v["sku"]
       self.quantity = v["quantity"]
       self.original_id = v["id"]
       dd= v.keys.select { |d| d.to_s.start_with?('price') } 
       dd.each do |k|
       
        p= Price.new
        self.prices << p.new_price(k.to_s, v[k]) 
       end    
       return self
       
    end
end
