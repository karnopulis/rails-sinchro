class OldCollect < ApplicationRecord
  belongs_to :result
  
  
  def self.create_new (item,col_id)
      nc = OldCollect.new 
      nc.collect_original_id=col_id
      nc.collection_flat=item[1]
      nc.product_scu=item[0]
      nc.error=nil
      nc.state=nil
      return nc
  end
end

