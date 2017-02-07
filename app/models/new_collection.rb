class NewCollection < ApplicationRecord
  belongs_to :result
  belongs_to :new_parent, class_name: "NewCollection"
  has_many :new_collects
  
  
   def self.create_new(item,par_cur,par_new,title,state)
      nc = NewCollection.new 
      nc.collection_flat=item
      nc.title = title
      nc.parent_id = par_cur
      nc.new_parent = par_new
      nc.error=nil
      nc.state=state
      return nc
  end
  
  def apply
     result = self.result.compare.site.add_Collection_to_insales(self)
     if result 
         self.state="completed"
         self.save
         self.update_listing(result["id"])
     else
         self.state="error"
         self.save
         self.error_handler
     end
  end
  def error_handler
      
  end
  def update_listing(id)
     self.result.new_collections.where(:new_parent =>self.id).update_all(:parent_id =>id, :state=>"listing")
     self.result.new_collects.where(:new_collection =>self.id).update_all(:collection_original_id =>id, :state=>"listing")
     self.result.new_collects.where(:new_collection =>self.id).where.not(:product_original_id => nil).update_all(:state=>"listing")
  end
  
end
