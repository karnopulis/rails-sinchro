class PictureImport < ApplicationRecord
    belongs_to :offer_import
    
     def self.create_new(url,oi,scu) 
        pi = self.new
        pi.url = url
        pi.offer_import=oi
        pi.scu=scu
    return pi
  end
end
