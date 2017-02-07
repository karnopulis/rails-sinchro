class OldCollect < ApplicationRecord
  belongs_to :result
  
  
  def self.create_new (item,col_id)
      nc = OldCollect.new 
      nc.collect_original_id=col_id
      nc.collection_flat=item[1]
      nc.product_scu=item[0]
      nc.error=nil
      nc.state="listing"
      return nc
  end
  def apply
     result = self.result.compare.site.delete_Collect_from_insales(self)
     if result 
         self.state="completed"
         self.save
     else
         self.state="error"
         self.save
         self.error_handler
     end
  end
  def error_handler
      
  end
end

