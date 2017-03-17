class Result < ApplicationRecord
  belongs_to :compare
  has_many :new_collects, dependent: :delete_all
  has_many :old_collects, dependent: :delete_all
  has_many :new_collections, dependent: :delete_all
  has_many :old_collections, dependent: :delete_all
  has_many :new_offers, dependent: :delete_all
  has_many :old_offers, dependent: :delete_all
  has_many :edit_offers, dependent: :delete_all
  has_many :edit_variants, dependent: :delete_all
  has_many :edit_collections, dependent: :delete_all
  has_many :new_pictures, dependent: :delete_all
  has_many :old_pictures, dependent: :delete_all



 def validate_before_apply
     os =self.compare.offers.size 
     ois = self.compare.offer_imports.size
     dopusk=(os+ois)/20
     puts dopusk
     puts (os-ois).abs
     if (os-ois).abs > dopusk 
        self.compare.status_trackers.add("WARN","Количество товаров на сайте и в выгрузке сильно различается ") 
        self.compare.status_trackers.add("FATAL","Внесение изменений прервано. Проверьте задачу и запустите ее вручную") 
        return nil
        
     else
        return true
     end 
 end

 def apply
     self.compare.status_trackers.add("INFO","Запуск процесса внесения изменений") 
     return "beware!" if validate_before_apply.nil?
     pid_errors = Spawnling.new do
        HandlerError.cicle(self.compare,false)
     end
    self.cicle
    compare.status_trackers.add("DEBUG","Окончание прямого процесса")
    loop do
        if  self.compare.handler_errors.where( "tryes_left > 0").size == 0 
            puts pid_errors.handle
            Process.kill("HUP",pid_errors.handle)
            compare.status_trackers.add("DEBUG","Окончание процесса обработчика ошибок")
            break
        end
        sleep 10
    end
     if self.compare.handler_errors.size > 0 
         self.cicle
     end
     c =self.compare
     c.name= self.compare.name + " "+ Time.now.to_formatted_s(:time) if c.name
     c.save
     self.compare.status_trackers.add("INFO","Завершение процесса внесения изменений") 

 end
 
 
 def cicle
    pid_main = Spawnling.new do    
         self.new_collects.cicle(self.compare)
         self.old_collects.cicle(self.compare)
         self.new_collections.cicle(self.compare)
         self.old_collections.cicle(self.compare)
         self.edit_collections.cicle(self.compare)

         self.new_offers.cicle(self.compare)
         self.old_offers.cicle(self.compare)
         self.edit_offers.cicle(self.compare)
         self.edit_variants.cicle(self.compare)
         self.new_pictures.cicle(self.compare)
         self.old_pictures.cicle(self.compare)
    
         puts Process.waitall
    end 
    Spawnling.wait(pid_main) 
    
 end
  
 def add_new_images (edited_images)
   new_pictures=[]
   edited_images.each do |e| 
     poid= self.compare.offers.where(:scu => e[0]).first.original_id
     imgs= self.compare.offer_imports.where(:scu => e[0]).first.picture_imports
     imgs.each do |pi|
        new_pictures << NewPicture.create_new(e[0],poid,pi.url,pi.position,self,nil)
     end
     
   end
   NewPicture.import new_pictures
 end
 
 def add_old_images (edited_images)
   old_pictures=[]
   edited_images.each do |e|
    self.compare.offers.where("scu" => e[0]).first.pictures.each do |p|
      old_pictures << OldPicture.create_new(e[0],p.original_id,p.offer.original_id)
      old_pictures.last.result=self
    end
    
   end
   OldPicture.import old_pictures
 end
  
 def add_edit_offers (edited_offers)
   e_offers=[]
   edited_offers.each do |item|
     orig = self.compare.offers.where( :scu => item[0]).pluck("original_id").first
     oi = self.compare.offer_imports.where( :scu => item[0]).pluck("prop_flat","title","sort_order").first
 
     e_offers << EditOffer.create_new(item[0],orig,oi[0],oi[1],oi[2],self,nil)
   end
   EditOffer.import e_offers
 end
 
 def add_edit_variants (edited_variants)
   e_variants=[]
    edited_variants.each do |item|
     orig = self.compare.offers.where( :scu => item[0]).first.variants.pluck("original_id").first
     vi= self.compare.variant_imports.where( :scu => item[0]).pluck("pric_flat","quantity").first
     e_variants << EditVariant.create_new(item[0],orig,vi[0],vi[1],self,nil)
   end
   EditVariant.import e_variants
 end
 
 def add_new_offers(no)

    no.each_slice(400) do |slice|
         new_offers=[]
         edit_offers=[]
         edit_variants=[]
         new_pictures=[]
         slice.each do |item|
                off_import = self.compare.offer_imports.find_by scu: item
                var_import = self.compare.variant_imports.find_by scu: item
               no =NewOffer.create_new(item,self)
               new_offers<< no
               edit_offers << EditOffer.create_new(item,nil,off_import.prop_flat,off_import.title,off_import.sort_order,self,no)
               edit_variants << EditVariant.create_new(item,nil,var_import.pric_flat,var_import.quantity,self,no)
              off_import.picture_imports.each do |pi|
                  new_pictures << NewPicture.create_new(item,nil,pi.url,pi.position,self,no)
              end
         end
         NewOffer.import new_offers
         keys= new_offers.map(&:scu)
         no_ids = NewOffer.where(:result=>self,:scu=>keys).pluck(:scu,:id).to_h
         edit_offers.each { |n| n.new_offer_id= no_ids[n.scu] }
         EditOffer.import edit_offers 
         edit_variants.each { |n| n.new_offer_id= no_ids[n.scu] }
         EditVariant.import edit_variants
         new_pictures.each { |n| n.new_offer_id= no_ids[n.scu] }
         NewPicture.import new_pictures
        #  new_offers.clear
        #  edit_offers.clear
        #  edit_variants.clear
        #  new_pictures.clear
    end
 end
 def add_old_offers(oo,oo_ids)
      old_offers=[]
      oo_scu=""
      oo_ids.each do |item|
        off = self.compare.offers.find_by original_id: item
        if oo.include? off.scu 
            oo_scu = off.scu
        else
#            puts item
            oo_scu = off.scu.to_s
            oo_scu+=" DUPLICATE" 
        end
        old_offers<< OldOffer.create_new(oo_scu,item)
        old_offers.last.result =self
      end
      OldOffer.import old_offers
 end
 
 def add_new_collections(nc)
    nc.sort!
    new_collections=[]
    nc.each do |item|
      parent_flat_arr = item.split(';').compact
      title = parent_flat_arr.pop
      parent_flat =parent_flat_arr.join(';')+";"
      parent = self.compare.collections.find_by flat: parent_flat
      current = self.compare.collect_imports.find_by flat: item
      if parent_flat_arr.size==0
          state="listing"
#          puts "+============================"
#          puts self.compare.global_parent_id
          parent_id =self.compare.global_parent_id
      else
          if parent
            state="listing"
            parent_id = parent.original_id
          else
            state="waiting"        
            parent_new = self.new_collections.find_by collection_flat: parent_flat 
          end
      end
      self.new_collections << NewCollection.create_new(item, parent_id ,parent_new, title, current.position, state)
    #   new_collections.last.result=self
    end
    # new_collections.each do |c|
    #     c.run_callbacks(:save) { false }
    # end
    # NewCollection.import new_collections  
  end
  
  def add_old_collections(nc)
    nc.sort!

    old_collections=[]
    nc.each do |item|
      current = self.compare.collections.find_by flat: item 
#      parent_new =self.old_collections.where("collection_flat LIKE ?", "%#{item}%").first
      parent_flat = item.split(';').compact
      title = parent_flat.pop
      parent_flat =parent_flat.join(';')+";"
      parent_new = self.old_collections.find_by collection_flat: parent_flat 
#      puts parent_new.try(:attributes)
      if nc.select { |s| s.include?(item) }.size> 1
        state="waiting"    
      else
        state="listing"   
      end
#      puts "==========================="
      self.old_collections << OldCollection.create_new(item,current.try(:original_id),parent_new.try(:id),state)
#      old_collections.last.result=self
    end
    #OldCollection.import old_collections
#    self.old_collections << old_collections
  end
  
  def add_new_collects(nc)
    nc.each_slice(2000) do |slice|
        new_collects=[]
        slice.each do |item|
              col_id = self.compare.collections.where(:flat => item[1]).pluck(:original_id)
              off_id = self.compare.offers.where(:scu => item[0]).pluck(:original_id)
              if col_id.empty? or off_id.empty?
                state="waiting"  
              else
                state="listing"   
              end
              new_col_id = self.new_collections.where(:collection_flat => item[1]).first if col_id.none?
              new_off_id = self.new_offers.where(:scu => item[0]).first if off_id.none?

              new_collects << NewCollect.create_new( item, col_id.first, off_id.first, new_col_id,new_off_id,state )
              new_collects.last.result=self
        end
        NewCollect.import new_collects
        new_collects=nil
    end
  end
  
  def add_old_collects(oc)
    old_collects=[]
    oc.each do |item|
      col_id = self.compare.collects.includes(:collection,:offer).where("collections.flat=? and offers.scu=?",
               item[1],item[0]).references(:collection,:offer).pluck("collects.original_id")
      old_collects << OldCollect.create_new(item,col_id.first)
      old_collects.last.result=self
    end
    OldCollect.import old_collects
  end
  
  def add_edit_collections(ec)
      edit_collections=[]
      ec.each do |e|
          oc =OldCollection.new
          orig = self.compare.collections.where(:flat => e[1]).pluck(:original_id).first
          pos = self.compare.collect_imports.where(:flat => e[1]).first.position
          edit_collections << EditCollection.create_new(e[1],pos,orig,self) if pos          
      end
     EditCollection.import edit_collections 
  end
  
end
