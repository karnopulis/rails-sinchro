class NewPicture < ActiveRecord::Base
  belongs_to :result   
    def self.create_new(scu,original_id,url)
        np =NewPicture.new 
        np.scu= scu
        np.original_offer_id = original_id
        np.url=url
        return np
    end 
end
