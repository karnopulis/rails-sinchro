class PictureImport < ApplicationRecord
    belongs_to :offer_import
    
     def self.create_new(url,oi,scu,pos,size) 
        pi = self.new
        pi.url = url
        pi.offer_import=oi
        pi.scu=scu
        pi.filename= url.split("/").last
        pi.position=pos
        pi.size=size
    return pi
  end
end
