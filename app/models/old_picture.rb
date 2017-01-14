class OldPicture < ApplicationRecord
   belongs_to :result
        def self.create_new (scu,original_id)
        op =OldPicture.new 
        op.scu= scu
        op.original_id = original_id
        return op
    end 
end
