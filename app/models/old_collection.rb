class OldCollection < ApplicationRecord
  belongs_to :result
  has_one :old_collection
  
   def self.create_new(item,cur_id,par,state)
      oc =OldCollection.new 
      oc.collection_flat=item
      oc.collection_original_id=cur_id
      oc.old_collection_id = par
      oc.error=nil
      oc.state=state
      return oc
  end
  
  def apply
     result = self.result.compare.site.delete_Collection_from_insales(self)
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
  def update_listing
 #    self.result.old_collections.where(:old_collection =>self.id).update_all(:state=>"listing")
#     self.result.old_collects.where(:new_collection =>self.id).update_all(:collection_original_id =>id, :state=>"listing")
  end
  
end
