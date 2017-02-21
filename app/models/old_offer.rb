class OldOffer < ApplicationRecord
  belongs_to :result


  def self.create_new (item,off_id)
      nc = OldOffer.new 
      nc.original_id=off_id
      nc.scu=item
      nc.error=nil
      nc.state="listing"
      return nc
  end
   def self.cicle(compare)
        pid = Spawnling.new do
            compare.status_trackers.add("DEBUG","Запуск процесса удаления продуктов") 

            loop do 
                 list = where(:state => "listing" ).to_a
                 compare.status_trackers.add("DEBUG",list.size) 
                 num =where(:id => list.pluck("id") ).update_all(state: "active")
                 compare.status_trackers.add("DEBUG",num) 
                 list.each do|nc|
                     nc.apply
                 end  
  
                old_offers = where(:state => "listing" )
            break if  old_offers.size == 0
            end
            compare.status_trackers.add("DEBUG","Окончание процесса удаления продуктов") 

        end    
    end

   def apply
     result = self.result.compare.site.delete_Product_from_insales(self)
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
