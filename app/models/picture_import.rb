class PictureImport < ApplicationRecord
    belongs_to :offer_import
    
     def self.create_new(url,oi) 
        pi = self.new
        pi.url = url
        pi.offer_import=oi
    return pi
  end
end
