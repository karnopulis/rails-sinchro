class HandlerError < ApplicationRecord
  belongs_to :compare
  
def self.create_new(model,model_id,message)
      he=HandlerError.new
      he.model=model
      he.model_id=model_id
      he.message=message.truncate(254)
      he.tryes_left =3
      he.save
      return he
  end
  def self.create_new_no_save(model,model_id,message)
      he=HandlerError.new
      he.model=model
      he.model_id=model_id
      he.message=message
      he.tryes_left =3
      return he
  end
  
  def self.cicle(compare,term)
   
        begin
            compare.status_trackers.add("INFO","Запуск процесса обработчика ошибок") 
            loop do 
                
                errors = compare.handler_errors.where.not(:tryes_left=> 0 )
#                logger.error errors.size
#                logger.error term
                errors.each do |e|
#                    puts e.model
                   obj = compare.result.try(e.model).find(e.model_id) 
                   result = obj.apply
                   if result 
                       logger.error e.model
                       logger.error e.model_id

                       #logger.error result
                       e.message= e.message + "|" + result.to_s 
                       #logger.error e.message
                       
                       #logger.error "-- -- - -- -- - - - --"
                       e.tryes_left-=1
                       e.save
                      if e.tryes_left == 0
                          obj.state= "FATAL"
                          obj.save
                      end
                   else
                       e.tryes_left=0
                       e.save
                   end
                end
                sleep 10
#                Signal.trap("HUP") { compare.status_trackers.add("DEBUG","Окончание процесса обработчика ошибок") ; exit }
                
#            break if errors.size == 0 && term==true
            end
            
        rescue Exception => exc
                if exc.message != "SIGHUP"
                        logger.error exc.message
                        logger.error exc.backtrace
                end
        end

  end
  
  
end
