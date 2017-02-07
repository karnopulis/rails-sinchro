class Result < ApplicationRecord
  belongs_to :compare
  has_many :new_collects, dependent: :destroy
  has_many :old_collects, dependent: :destroy
  has_many :new_collections, dependent: :destroy
  has_many :old_collections, dependent: :destroy
  has_many :new_offers, dependent: :destroy
  has_many :old_offers, dependent: :destroy
  has_many :edit_offers, dependent: :destroy
  has_many :edit_variants, dependent: :destroy
  has_many :new_pictures, dependent: :destroy
  has_many :old_pictures, dependent: :destroy

 def apply
     loop do 
         self.new_collections.where(:state => "listing" ).update_all(state: "active")
         self.new_collections.where(:state => "active" ).each do|nc|
             nc.apply
         end
         new_collections =self.new_collections.where(:state => "listing" )
        break if  new_collections.size == 0
    end
    loop do 
         pack = self.old_collections.where(:state => "listing" )
         pack.update_all(state: "active")
         pack = self.old_collections.where(:state => "active" )
         puts pack
         pack.each do|oc|
             puts ="=========="
             oc.apply
         end
         parent_ids = pack.pluck(:old_collection_id).uniq.compact
         puts parent_ids
         parent_ids.each do |pi|
             r= self.old_collections.where(:old_collection_id => pi).where.not(:state =>"completed")
             puts r
             if  r.size== 0
                 cur =self.old_collections.find(pi)
                 cur.state="listing"
                 cur.save
             end
         end

        break if  parent_ids.size == 0
    end
    loop do
        self.new_offers.where(:state => "listing" ).update_all(state: "active")
        self.new_offers.where(:state => "active" ).each do|no|
             no.apply
                 

         end
         new_offers =self.new_offers.where(:state => "listing" )
    break if  new_offers.size == 0
    end
    loop do
        self.old_offers.where(:state => "listing" ).update_all(state: "active")
        self.old_offers.where(:state => "active" ).each do|oo|
             oo.apply

         end
         old_offers =self.new_offers.where(:state => "listing" )
    break if  old_offers.size == 0
    end
    loop do
        self.edit_offers.where(:state => "listing" ).update_all(state: "active")
        self.edit_offers.where(:state => "active" ).each do|oo|
             oo.apply
         end
         edit_offers =self.edit_offers.where(:state => "listing" )
    break if  edit_offers.size == 0
    end
    loop do
        self.edit_variants.where(:state => "listing" ).update_all(state: "active")
        self.edit_variants.where(:state => "active" ).each_slice(100) do|slice|
             EditVariant.apply_bulk(slice,self)
         end
         edit_variants =self.edit_variants.where(:state => "listing" )
         
    break if  edit_variants.size == 0
    end
    loop do
        self.new_pictures.where(:state => "listing" ).update_all(state: "active")
        self.new_pictures.where(:state => "active" ).each do|np|
             np.apply
         end
         new_pictures =self.new_pictures.where(:state => "listing" )
         
    break if  new_pictures.size == 0
    end
        loop do
        self.old_pictures.where(:state => "listing" ).update_all(state: "active")
        self.old_pictures.where(:state => "active" ).each do|op|
             op.apply
         end
         old_pictures =self.old_pictures.where(:state => "listing" )
         
    break if  old_pictures.size == 0
    end
    loop do
         self.old_collects.where(:state => "listing" ).update_all(state: "active")
         self.old_collects.where(:state => "active" ).each do|oc|
              oc.apply
          end
          old_collects =self.old_collects.where(:state => "listing" )
         
    break if  old_collects.size == 0
    end
    loop do
         self.new_collects.where(:state => "listing" ).update_all(state: "active")
         self.new_collects.where(:state => "active" ).each do|nc|
              nc.apply
          end
          new_collects =self.new_collects.where(:state => "listing" )
         
     break if  new_collects.size == 0
     end
     c =self.compare
     c.name= self.compare.name + " "+ Time.now.to_formatted_s(:time) if c.name
     c.save
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
            puts item
            oo_scu = off.scu
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
      parent_flat = item.split(';').compact
      title = parent_flat.pop
      parent_flat =parent_flat.join(';')+";"
      parent = self.compare.collections.find_by flat: parent_flat
      if item ==  title
          state="listing"
          puts "+============================"
          puts self.compare.global_parent_id
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
      self.new_collections << NewCollection.create_new(item, parent_id ,parent_new, title, state)
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
      puts parent_new.try(:attributes)
      if nc.select { |s| s.include?(item) }.size> 1
        state="waiting"    
      else
        state="listing"   
      end
      puts "==========================="
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
  def edit_Collection_temp
      ec=[]
      self.compare.collections.each do |e|
          oc =OldCollection.new
          oc.collection_original_id=e.original_id
          self.compare.site.edit_Collection_to_insales(oc)
          
      end
  end
  
end
