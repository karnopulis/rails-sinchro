class NewCollection < ApplicationRecord
  belongs_to :result
  belongs_to :new_parent, class_name: "NewCollection"
  has_many :new_collects
  
  
   def self.create_new(item,par_cur,par_new,title)
      nc = NewCollection.new 
      nc.collection_flat=item
      nc.title = title
      nc.parent_id = par_cur
      nc.new_parent = par_new
      nc.error=nil
      nc.state=nil
      return nc
  end
end
