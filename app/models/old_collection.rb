class OldCollection < ActiveRecord::Base
  belongs_to :result
  has_one :old_collection
  
   def self.create_new(item,cur_id,par)
      oc =OldCollection.new 
      oc.collection_flat=item
      oc.collection_original_id=cur_id
      oc.old_collection = par
      oc.error=nil
      oc.state=nil
      return oc
  end
end
