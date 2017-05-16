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
                    begin
                         nc.apply
                    rescue Exception => exc
                        logger.error exc.message
                        logger.error exc.backtrace
                    end
                 end  
  
                old_collects = where(:state => "listing" )
            break if  old_collects.size == 0
                
            end
            compare.status_trackers.add("DEBUG","Окончание процесса удаления размещений") 
        end    
    end
  
  def apply
     result = self.result.compare.site.delete_Collect_from_frontend(self)
     if result[:status]=="ok" 
         self.state="completed"
         self.save
#         self.update_listing(result["id"])
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
      self.result.compare.handler_errors << HandlerError.create_new("old_collects",self.id,error)
  end
end

