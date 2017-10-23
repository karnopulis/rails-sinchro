class Variant < ApplicationRecord
    belongs_to :offer
    belongs_to :compare
    has_many :prices, dependent: :destroy
    
    
    def new_from_hash (v,compare,offer)
       self.sku = v["sku"]
       self.quantity = v["quantity"]
       self.original_id = v["id"]
       flat=[]
       #dd= v.keys.select { |d| d.to_s.start_with?('price') } 
       compare.site.site_variant_order.split(",").each do |k|
        p= Price.new
#        puts k
#        puts v[k]
        flat << v[k].to_s
        prices << p.new_price(k, v[k],v["sku"]) 
       end
       self.flat=flat.join(";")
       self.offer=offer
       self.compare=compare
       return self,prices
       
    end
end
