class EditCollection < ApplicationRecord
  belongs_to :result

    def self.create_new (flat,pos,orig,result)
        ec = EditCollection.new
        ec.original_id = orig
        ec.position = pos
        ec.flat = flat
        ec.result = result
        ec.error=nil
        ec.state="listing"  
        
        return ec        
    end


def self.cicle(compare)
        pid = Spawnling.new do
            compare.status_trackers.add("DEBUG","Запуск процесса редактирования коллекций") 

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
  
                edit_collections = where(:state => "listing" )
            break if  edit_collections.size == 0
                 
            end
            compare.status_trackers.add("DEBUG","Окончание процесса редактирования коллекций")
        end    
    end
    
     def apply
     result = self.result.compare.site.edit_Collection_to_frontend(self)
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
      self.result.compare.handler_errors << HandlerError.create_new("edit_collections",self.id,error)
  end




end
