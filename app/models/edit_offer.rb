class EditOffer < ApplicationRecord
    belongs_to :new_offer
    belongs_to :result
    
     def self.create_new (scu,orig,flat,name,so,result,no)
        eo = EditOffer.new
        eo.scu = scu
        eo.title = name
        eo.original_id = orig
        eo.flat = flat
        eo.sort_weight=so
        eo.new_offer=no
        eo.result=result
        eo.error=nil
        no==nil ? eo.state="listing" : eo.state="waiting" 
        
        return eo
    end
    
      def apply
     result = self.result.compare.site.edit_Product_to_insales(self)
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
