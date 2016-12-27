class Characteristic < ActiveRecord::Base
    
    belongs_to :offer
    belongs_to :property
end

