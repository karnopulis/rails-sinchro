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
        ev.state=nil
        
        return ev        
    end
end
