class EditVariant < ApplicationRecord
    
    belongs_to :new_offer
    belongs_to :result
    
    def self.create_new (scu,orig,flat,qo,result,no)
        ev = EditVariant.new
        ev.scu = scu
        ev.quantity = qo
        ev.original_id = orig
        ev.flat = flat
        ev.result = result
        ev.new_offer=no
        ev.error=nil
        no==nil ? ev.state="listing" : ev.state="waiting" 
        
        return ev        
    end
    
     def self.apply_bulk(variants,result)
         res = result.compare.site.edit_Variants_to_insales(variants)
         
         errors = res.select {|r| r["status"]!="ok"}

         success = res.select {|r| r["status"]=="ok"}
         succ= success.map{ |m| m["id"] }
         result.edit_variants.where(:original_id => succ).update_all(:state =>"completed")
         EditVariant.error_handler(errors)
     
    end
      def self.error_handler(errors)
          
      end
end
