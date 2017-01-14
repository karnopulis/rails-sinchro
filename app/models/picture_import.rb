class PictureImport < ApplicationRecord
    belongs_to :offer_import
    
     def self.create_new(url) 
        pi = self.new
        pi.url = url

    return pi
  end
end
