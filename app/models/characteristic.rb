class Characteristic < ActiveRecord::Base
    
    belongs_to :offer
    belongs_to :property
    
    
    def self.create_new(pr,of,ori,title)
        c = Characteristic.new()
        c.original_id = ori
        c.offer = of
        c.title= title
        c.property =pr
        return c
    end
end

