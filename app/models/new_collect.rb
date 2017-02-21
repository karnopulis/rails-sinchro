class NewCollect < ApplicationRecord
  belongs_to :result
  belongs_to :new_collection
  belongs_to :new_product
  
  
  def self.create_new (item,col_id,off_id,new_col,new_off,state)
      nc = NewCollect.new 
      nc.collection_original_id=col_id
      nc.collection_flat=item[1]
      nc.product_original_id=off_id
      nc.product_scu=item[0]
      nc.error=nil
      nc.state=state
      nc.new_collection_id = new_col.try(:id)
      
      nc.new_product_id = new_off.try(:id)
      return nc
  end
  
  def self.cicle(compare)
       pid = Spawnling.new do
            compare.status_trackers.add("DEBUG","Запуск процесса добавления размещений") 

            loop do 
                 list = where(:state => "listing" ).to_a
                 compare.status_trackers.add("DEBUG",list.size) 
                 num =where(:id => list.pluck("id") ).update_all(state: "active")
                 compare.status_trackers.add("DEBUG",num) 
                 list.each do|nc|
                     nc.apply
                 end  
  
                new_collects = where(:state => "listing" )
            break if  new_collects.size == 0
            end
            compare.status_trackers.add("DEBUG","Окончание процесса добавления размещений") 

        end    
    end
  
  def apply
     result = self.result.compare.site.add_Collect_to_insales(self)
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
