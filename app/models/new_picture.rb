class NewPicture < ApplicationRecord
  belongs_to :result   
  belongs_to :new_offer
    def self.create_new(scu,original_id,url,pos,size,result,no)
        np =NewPicture.new 
        np.scu= scu
        np.original_offer_id = original_id
        np.url=url
        np.position=pos
        np.result=result
        np.new_offer=no
        np.size=size
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
                    begin
                         nc.apply
                    rescue Exception => exc
                        logger.error exc.message
                        logger.error exc.backtrace
                    end
                 end  
  
                new_images = where(:state => "listing" )
            break if  new_images.size == 0
                
            end
            compare.status_trackers.add("DEBUG","Окончание процесса добавления изображений") 
        end    
    end
    
    def apply
     result = self.result.compare.site.add_Picture_to_frontend(self)
     if result[:status]=="ok" 
         self.state="completed"
         self.save
#         puts result
         return nil
     else if  self.state=="error"
              return result[:error]
          else 
             self.state="error"
             self.save
            #  if eh.nil?
            #     self.result.compare.status_trackers.add("DEBUG","Запуск обработчика ошибок добавления коллекций") 
            #     eh = Spawnling.new do
                    self.error_handler( result[:error] )
            #     end
            # end
        end
     end
  end
  def error_handler(error)
      self.result.compare.handler_errors << HandlerError.create_new("new_pictures",self.id,error)
  end
end
