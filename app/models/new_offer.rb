


class NewOffer < ApplicationRecord
    has_many :edit_offers, dependent: :destroy
    has_many :edit_variants, dependent: :destroy
    has_many :new_pictures, dependent: :destroy
    belongs_to :result
    
    
  def self.create_new (item,result)
          nc = NewOffer.new 
          nc.scu=item
          nc.error=nil
          nc.state=nil
          nc.result=result
      return nc
  end
end
