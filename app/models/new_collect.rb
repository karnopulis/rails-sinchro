class NewCollect < ApplicationRecord
  belongs_to :result
  belongs_to :new_collection
  belongs_to :new_product
  
  
  def self.create_new (item,col_id,off_id,new_col,state)
      nc = NewCollect.new 
      nc.collection_original_id=col_id
      nc.collection_flat=item[1]
      nc.product_original_id=off_id
      nc.product_scu=item[0]
      nc.error=nil
      nc.state=state
      nc.new_collection = new_col
#      nc.new_product = nil
      return nc
  end
end
