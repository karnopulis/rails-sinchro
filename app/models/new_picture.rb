class NewPicture < ApplicationRecord
  belongs_to :result   
  belongs_to :new_offer
    def self.create_new(scu,original_id,url)
        np =NewPicture.new 
        np.scu= scu
        np.original_offer_id = original_id
        np.url=url
        return np
    end 
end
