


class NewOffer < ActiveRecord::Base
    has_many :edit_offers, dependent: :destroy
    has_many :edit_variants, dependent: :destroy
    belongs_to :result
    
    
      def self.create_new (item)
          nc = NewOffer.new 
          nc.scu=item
          nc.error=nil
          nc.state=nil
      return nc
  end
end
