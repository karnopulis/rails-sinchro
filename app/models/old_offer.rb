class OldOffer < ApplicationRecord
  belongs_to :result


  def self.create_new (item,off_id)
      nc = OldOffer.new 
      nc.original_id=off_id
      nc.scu=item
      nc.error=nil
      nc.state="listing"
      return nc
  end
  
   def apply
     result = self.result.compare.site.delete_Product_from_insales(self)
     if result 
         self.state="completed"
         self.save
     else
         self.state="error"
         self.save
         self.error_handler
     end
  end
  def error_handler
      
  end
end
