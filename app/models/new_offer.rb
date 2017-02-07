


class NewOffer < ApplicationRecord
    has_many :edit_offers, dependent: :destroy
    has_many :edit_variants, dependent: :destroy
    has_many :new_pictures, dependent: :destroy
    belongs_to :result
    
    
  def self.create_new (item,result)
          nc = NewOffer.new 
          nc.scu=item
          nc.error=nil
          nc.state="listing"
          nc.result=result
      return nc
  end
  
  def apply
     result = self.result.compare.site.add_Product_to_insales(self)
     if result 
         self.state="completed"
         self.edit_variants.each {|v| v.state="completed" ; v.save}
         self.edit_offers.each {|v| v.state="completed" ; v.save}
         self.save!
         self.update_listing(result["id"],result["variants"])
     else
         self.state="error"
         self.save
         self.error_handler
     end
  end
  def error_handler
  end
  def update_listing(id,var_ids)
     self.result.new_collects.where(:new_product_id =>self.id).update_all(:product_original_id =>id)
     self.result.new_collects.where(:new_product_id =>self.id).where.not(:collection_original_id=> nil).update_all(:state=>"listing")
     self.result.new_pictures.where(:new_offer_id =>self.id).update_all(:original_offer_id =>id,:state=>"listing")
    #  var_ids.each do |v|
    #      puts v["id"]
    #  end
  end
end
