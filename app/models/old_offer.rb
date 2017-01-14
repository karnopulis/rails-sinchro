class OldOffer < ApplicationRecord
  belongs_to :result


  def self.create_new (item,off_id)
      nc = OldOffer.new 
      nc.original_id=off_id
      nc.scu=item
      nc.error=nil
      nc.state=nil
      return nc
  end
end
