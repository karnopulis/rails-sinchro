class Site < ActiveRecord::Base
    has_many :compares, dependent: :destroy
    
end
