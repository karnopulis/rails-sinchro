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
  
  def self.cicle(compare)
        pid = Spawnling.new do
            compare.status_trackers.add("DEBUG","Запуск процесса удаления коллекций") 

            loop do 
                 list = where(:state => "listing" ).to_a
                 compare.status_trackers.add("DEBUG",list.size) 
                 num =where(:id => list.pluck("id") ).update_all(state: "active")
                 compare.status_trackers.add("DEBUG",num) 
                 list.each do|nc|
                     nc.apply
                 end 
                 parent_ids = list.pluck(:old_collection_id).uniq.compact
                #  puts parent_ids
                 parent_ids.each do |pi|
                     r= where(:old_collection_id => pi).where.not(:state =>"completed")
                    #  puts r
                     if  r.size== 0
                         cur =find(pi)
                         cur.state="listing"
                         cur.save
                     end
                 end
                 
                break if  parent_ids.size == 0
                
            end
            compare.status_trackers.add("DEBUG","Окончание процесса удаления коллекций") 
        end    
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
