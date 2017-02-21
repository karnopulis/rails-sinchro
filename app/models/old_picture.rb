class OldPicture < ApplicationRecord
   belongs_to :result
        def self.create_new (scu,original_id,original_offer_id)
        op =OldPicture.new 
        op.scu= scu
        op.original_id = original_id
        op.original_offer_id =original_offer_id
        op.state ="listing"
        op.error =nil
        return op
    end 
    def self.cicle(compare)
        pid = Spawnling.new do
            compare.status_trackers.add("DEBUG","Запуск процесса удаления изображений") 

            loop do 
                 list = where(:state => "listing" ).to_a
                 compare.status_trackers.add("DEBUG",list.size) 
                 num =where(:id => list.pluck("id") ).update_all(state: "active")
                 compare.status_trackers.add("DEBUG",num) 
                 list.each do|nc|
                     nc.apply
                 end  
  
                old_images = where(:state => "listing" )
            break if  old_images.size == 0
                
            end
            compare.status_trackers.add("DEBUG","Окончание процесса удаления изображений") 
        end    
    end
    
    
     def apply
     result = self.result.compare.site.delete_Picture_from_insales(self)
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
