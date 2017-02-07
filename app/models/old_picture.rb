class OldPicture < ApplicationRecord
   belongs_to :result
        def self.create_new (scu,original_id,original_offer_id)
        op =OldPicture.new 
        op.scu= scu
        op.original_id = original_id
        op.original_offer_id =original_offer_id
        op.state ="listing"
        op.error =nil
        return op
    end 
     def apply
     result = self.result.compare.site.delete_Picture_from_insales(self)
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
