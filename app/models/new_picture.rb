class NewPicture < ApplicationRecord
  belongs_to :result   
  belongs_to :new_offer
    def self.create_new(scu,original_id,url,result,no)
        np =NewPicture.new 
        np.scu= scu
        np.original_offer_id = original_id
        np.url=url
        np.result=result
        np.new_offer=no
        return np
    end 
end
