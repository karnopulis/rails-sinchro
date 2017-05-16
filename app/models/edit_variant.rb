class EditVariant < ApplicationRecord
    
    belongs_to :new_offer
    belongs_to :result
    
    def self.create_new (scu,orig,flat,qo,result,no)
        ev = EditVariant.new
        ev.scu = scu
        ev.quantity = qo
        ev.original_id = orig
        ev.flat = flat
        ev.result = result
        ev.new_offer=no
        ev.error=nil
        no==nil ? ev.state="listing" : ev.state="waiting" 
        
        return ev        
    end
    
    def self.cicle(compare)
        pid = Spawnling.new do
            compare.status_trackers.add("DEBUG","Запуск процесса редактирования вариантов") 

            loop do 
                 list = where(:state => "listing" ).to_a
                 compare.status_trackers.add("DEBUG",list.size) 
                 num =where(:id => list.pluck("id") ).update_all(state: "active")
                 compare.status_trackers.add("DEBUG",num) 

                 list.each_slice(100) do|slice|
                    begin
                        EditVariant.apply_bulk(slice,compare.result)
                    rescue Exception => exc
                        logger.error exc.message
                        logger.error exc.backtrace

                    end
                 end  
  
                edit_variants = where(:state => "listing" )
            break if  edit_variants.size == 0
                 
            end
            compare.status_trackers.add("DEBUG","Окончание процесса редактирования вариантов")
        end    
    end
    
    
     def self.apply_bulk(variants,result)
         res = result.compare.site.edit_Variants_to_frontend(variants)
#         puts res
         errors = res.select {|r| r["status"]!="ok"}

         success = res.select {|r| r["status"]=="ok"}
         succ= success.map{ |m| m["id"] }
         result.edit_variants.where(:original_id => succ).update_all(:state =>"completed")
         err= errors.map{ |m| m["id"] }
         result.edit_variants.where(:original_id => err).update_all(:state =>"error")

#         EditVariant.error_handler(errors,result)
     
    end
    def apply
        puts self 
        variants=[]
        variants << self
        puts variants
        EditVariant.apply_bulk(variants, self.result)
    end
    def self.error_handler(errors,result)
        handler_errors=[]
        errors.each do |he|
            puts he
            ev =  result.edit_variants.find_by original_id: he["id"]
            puts ev.id
            handler_errors << HandlerError.create_new_no_save("edit_variants",ev.id,he["errors"].to_s)
            handler_errors.last.compare = result.compare 
        end
        HandlerError.import handler_errors
    end
end
