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
                    end
                 end  
  
                edit_variants = where(:state => "listing" )
            break if  edit_variants.size == 0
                 
            end
            compare.status_trackers.add("DEBUG","Окончание процесса редактирования вариантов")
        end    
    end
    
    
     def self.apply_bulk(variants,result)
         res = result.compare.site.edit_Variants_to_insales(variants)
         errors = res.select {|r| r["status"]!="ok"}

         success = res.select {|r| r["status"]=="ok"}
         succ= success.map{ |m| m["id"] }
         result.edit_variants.where(:original_id => succ).update_all(:state =>"completed")
         EditVariant.error_handler(errors)
     
    end
      def self.error_handler(errors)
          
      end
end
