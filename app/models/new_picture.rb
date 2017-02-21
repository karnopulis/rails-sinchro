class NewPicture < ApplicationRecord
  belongs_to :result   
  belongs_to :new_offer
    def self.create_new(scu,original_id,url,pos,result,no)
        np =NewPicture.new 
        np.scu= scu
        np.original_offer_id = original_id
        np.url=url
        np.position=pos
        np.result=result
        np.new_offer=no
        no==nil ? np.state="listing" : np.state="waiting" 
        np.error =nil
        return np
    end 
    
    def self.cicle(compare)
        pid = Spawnling.new do
            compare.status_trackers.add("DEBUG","Запуск процесса добавления изображений") 

            loop do 
                 list = where(:state => "listing" ).to_a
                 compare.status_trackers.add("DEBUG",list.size) 
                 num =where(:id => list.pluck("id") ).update_all(state: "active")
                 compare.status_trackers.add("DEBUG",num) 
                 list.each do|nc|
                     nc.apply
                 end  
  
                new_images = where(:state => "listing" )
            break if  new_images.size == 0
                
            end
            compare.status_trackers.add("DEBUG","Окончание процесса добавления изображений") 
        end    
    end
    
    def apply
     result = self.result.compare.site.add_Picture_to_insales(self)
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
