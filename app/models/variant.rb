class Variant < ApplicationRecord
    belongs_to :offer
    has_many :prices
    
    
    def new_from_hash (v,site)
       self.sku = v["sku"]
       self.quantity = v["quantity"]
       self.original_id = v["id"]
       flat=[]
       #dd= v.keys.select { |d| d.to_s.start_with?('price') } 
       site.site_variant_order.split(",").each do |k|
        p= Price.new
        flat << v[k].to_s
        self.prices << p.new_price(k, v[k]) 
       end
       self.flat=flat.join(";")
       return self
       
    end
end
