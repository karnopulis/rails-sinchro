


class NewOffer < ApplicationRecord
    has_many :edit_offers, dependent: :delete_all
    has_many :edit_variants, dependent: :delete_all
    has_many :new_pictures, dependent: :delete_all
    belongs_to :result
    
    
  def self.create_new (item,result)
          nc = NewOffer.new 
          nc.scu=item
          nc.error=nil
          nc.state="listing"
          nc.result=result
      return nc
  end
  def self.cicle(compare)
        pid = Spawnling.new do
            compare.status_trackers.add("DEBUG","Запуск процесса добавления продуктов") 

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
                    end
                end  
  
                new_offers = where(:state => "listing" )
            break if  new_offers.size == 0
                
            end
            compare.status_trackers.add("DEBUG","Окончание процесса добавления продуктов") 
        end
        Spawnling.wait(pid)
        compare.result.new_collects.cicle(compare)
        compare.result.new_pictures.cicle(compare)
      
    end
  
  def apply
     result = self.result.compare.site.add_Product_to_insales(self)
     if result 
         self.state="completed"
         self.edit_variants.each {|v| v.state="completed" ; v.save}
         self.edit_offers.each {|v| v.state="completed" ; v.save}
         self.save!
         self.update_listing(result["id"],result["variants"])
     else
         self.state="error"
         self.save
         self.error_handler
     end
  end
  def error_handler
  end
  def update_listing(id,var_ids)
     self.result.new_collects.where(:new_product_id =>self.id).update_all(:product_original_id =>id)
     self.result.new_collects.where(:new_product_id =>self.id).where.not(:collection_original_id=> nil).update_all(:state=>"listing")
     self.result.new_pictures.where(:new_offer_id =>self.id).update_all(:original_offer_id =>id,:state=>"listing")
    #  var_ids.each do |v|
    #      puts v["id"]
    #  end
  end
end
