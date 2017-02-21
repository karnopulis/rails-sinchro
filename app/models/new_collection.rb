class NewCollection < ApplicationRecord
  belongs_to :result
  belongs_to :new_parent, class_name: "NewCollection"
  has_many :new_collects,dependent: :delete_all
  
  
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
    def self.cicle(compare)
        pid = Spawnling.new do
            compare.status_trackers.add("DEBUG","Запуск процесса добавления коллекций") 

            loop do 
#                compare.status_trackers.add("DEBUG", try(:class)) 

                 list = where(:state => "listing" ).to_a
                 compare.status_trackers.add("DEBUG",list.size) 
                 num =where(:id => list.pluck("id") ).update_all(state: "active")
                 compare.status_trackers.add("DEBUG",num) 
 #           compare.status_trackers.add("DEBUG",list.size) 
                 list.each do|nc|
                    begin
                         nc.apply
                    rescue Exception => exc
                        logger.error exc.message
                        logger.error exc.trace
                    end
                 end  
                 new_collections =where(:state => "listing" )
#            compare.status_trackers.add("DEBUG",new_collections) 
            puts "==========="
            puts     new_collections.size == 0
            puts "================="
            break if  new_collections.size == 0
            end
            compare.status_trackers.add("DEBUG","Окончание процесса добавления коллекций") 

        end 
        Spawnling.wait(pid)
        compare.result.new_collects.cicle(compare)
    end
  
  def apply
     result = self.result.compare.site.add_Collection_to_insales(self)
     if result 
         self.state="completed"
         self.save
         self.update_listing(result["id"])
         puts result
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

