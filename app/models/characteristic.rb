class Characteristic < ApplicationRecord
    
    belongs_to :offer
    belongs_to :property
    
    
    def self.create_new(pr,of,ori,title,scu)
        c = Characteristic.new()
        c.original_id = ori
        c.offer = of
        c.title= title
        c.scu=scu
        c.property =pr
        return c
    end
end

