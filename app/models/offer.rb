class Offer < ApplicationRecord
    has_many :pictures, dependent: :delete_all
    belongs_to :compare
    has_many :collects, dependent: :delete_all
    has_many :collections, :through => :collects
    has_many :characteristics, dependent: :delete_all
    has_many :properties, :through => :characteristics
    has_many :variants, dependent: :destroy 
  
  
  def destroy
      self.pictures.delete_all
      self.collects.delete_all
      self.characteristics.delete_all
      Price.where("variant_id"=>self.variant_ids).delete_all
      self.variants.delete_all 
      self.delete
      return self
  end
  
    # def initialize (h)
    #     new_from_hash (h)
    # end
    
    def new_from_hash_marketplace (h)
       self.original_id = h["id"]
       self.scu = h["vendorCode"]
       if ( h["picture"].class == Array )
             h["picture"].each do |a|
                p= Picture.new
                self.pictures << p.new_from_hash_marketplace( a )
             end 
         else 
            p= Picture.new
            self.pictures << p.new_from_hash_marketplace( h["picture"] )
         end
       return self
    end

    def new_from_hash_products (h , prop)
        characteristics=[]
        pictures=[]
        variants=[]
        prices=[]
       self.original_id = h["id"]
       scu = h["variants"].first["sku"]
       self.scu=scu
       self.title = h["title"]    
       flat=[]
       h["characteristics"].each do |c|
           prop_id = prop.index { |i| c["property_id"].to_i ==i.original_id }
           characteristics << Characteristic.create_new(prop[prop_id], self, c["id"], c["title"],scu)
        #     prop_id = prop.index { |i| c["property_id"].to_i ==i.original_id }
        #     self.properties<< prop[prop_id]
        #     self.characteristics.last.original_id= c["id"]
        #     self.characteristics.last.title=c["title"]
             flat << [prop[prop_id].title,c["title"]]
       end
        self.flat=flat.to_h.values_at(*self.compare.site.site_offer_order.split(",")).join(";")
        self.image_status=""
        self.sort_weight= h["sort_weight"]
         h["images"].each do |a|
            p= Picture.new
            self.image_status = self.image_status + a["filename"]+";"
            pictures << p.new_from_hash_products( a,self, scu)
         end 
         h["variants"].each do |d|
            v= Variant.new
            v,pri = v.new_from_hash(d,self.compare,self)
            variants << v
            prices=prices+pri
         end
       return variants,pictures,characteristics,prices
    end
end
