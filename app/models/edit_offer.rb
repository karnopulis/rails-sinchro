class EditOffer < ActiveRecord::Base
    belongs_to :new_offer
    belongs_to :result
    
     def self.create_new (scu,orig,flat,name)
        eo = EditOffer.new
        eo.scu = scu
        eo.title = name
        eo.original_id = orig
        eo.flat = flat
        eo.error=nil
        eo.state=nil
        return eo
    end
end
