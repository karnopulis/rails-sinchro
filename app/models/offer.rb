class Offer < ActiveRecord::Base
    has_many :pictures, dependent: :destroy
    belongs_to :compare
    has_many :collects, dependent: :destroy
    has_many :collections, :through => :collects
    has_many :characteristics, dependent: :destroy
    has_many :properties, :through => :characteristics
    has_many :variants, dependent: :destroy 
  
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
       self.original_id = h["id"]
       self.scu = h["variants"].first["sku"]
       self.title = h["title"]    
       flat=[]
       h["characteristics"].each do |c|
           prop_id = prop.index { |i| c["property_id"].to_i ==i.original_id }
           characteristics << Characteristic.create_new(prop[prop_id], self, c["id"], c["title"])
        #     prop_id = prop.index { |i| c["property_id"].to_i ==i.original_id }
        #     self.properties<< prop[prop_id]
        #     self.characteristics.last.original_id= c["id"]
        #     self.characteristics.last.title=c["title"]
             flat << [prop[prop_id].title,c["title"]]
       end
        self.flat=flat.to_h.values_at(*self.compare.site.site_offer_order.split(",")).join(";")
        self.image_status=""
         h["images"].each do |a|
            p= Picture.new
            self.image_status << a["filename"]+";"
            self.pictures << p.new_from_hash_products( a )
         end 
         h["variants"].each do |d|
            v= Variant.new
            self.variants << v.new_from_hash(d,self.compare.site)
         end

       return characteristics
    end
end
