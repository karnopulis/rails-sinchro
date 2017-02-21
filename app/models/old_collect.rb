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
  
  def self.cicle(compare)
       pid = Spawnling.new do
            compare.status_trackers.add("DEBUG","Запуск процесса удаления размещений") 

            loop do 
                 list = where(:state => "listing" ).to_a
                 compare.status_trackers.add("DEBUG",list.size) 
                 num =where(:id => list.pluck("id") ).update_all(state: "active")
                 compare.status_trackers.add("DEBUG",num) 
                 list.each do|nc|
                     nc.apply
                 end  
  
                old_collects = where(:state => "listing" )
            break if  old_collects.size == 0
                
            end
            compare.status_trackers.add("DEBUG","Окончание процесса удаления размещений") 
        end    
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

