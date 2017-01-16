class EditOffer < ApplicationRecord
    belongs_to :new_offer
    belongs_to :result
    
     def self.create_new (scu,orig,flat,name,so)
        eo = EditOffer.new
        eo.scu = scu
        eo.title = name
        eo.original_id = orig
        eo.flat = flat
        eo.sort_weight=so
        eo.error=nil
        eo.state=nil
        return eo
    end
end
