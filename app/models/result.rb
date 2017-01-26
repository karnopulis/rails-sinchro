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
         self.old_collections.where(:state => "listing" ).update_all(state: "active")
         self.old_collections.where(:state => "active" ).each do|oc|
             oc.apply
         end
         old_collections =self.old_collections.where(:state => "waiting" ).each do |cc|
               
         end
        break if  old_collections.size == 0
    end
 end
  
 def add_new_images (edited_images)
   new_pictures=[]
   edited_images.each do |e| 
     poid= self.compare.offers.where(:scu => e[0]).first.original_id
     imgs= self.compare.offer_imports.where(:scu => e[0]).first.picture_imports
     imgs.each do |pi|
        new_pictures << NewPicture.create_new(e[0],poid,pi.url,self,nil)
     end
     
   end
   NewPicture.import new_pictures
 end
 
 def add_old_images (edited_images)
   old_pictures=[]
   edited_images.each do |e|
    self.compare.offers.where("scu" => e[0]).first.pictures.each do |p|
      old_pictures << OldPicture.create_new(e[0],p.original_id)
      old_pictures.last.result=self
    end
    
   end
   OldPicture.import old_pictures
 end
  
 def add_edit_offers (edited_offers)
   e_offers=[]
   edited_offers.each do |item|
     orig = self.compare.offers.where( :scu => item[0]).pluck("original_id").first
     flat = self.compare.offer_imports.where( :scu => item[0]).pluck("prop_flat").first
     name = self.compare.offer_imports.where( :scu => item[0]).pluck("title").first
     so = self.compare.offer_imports.where( :scu => item[0]).pluck("sort_order").first
     e_offers << EditOffer.create_new(item[0],orig,flat,name,so,self,nil)
   end
   EditOffer.import e_offers
 end
 
 def add_edit_variants (edited_variants)
   e_variants=[]
    edited_variants.each do |item|
     orig = self.compare.offers.where( :scu => item[0]).first.variants.pluck("original_id").first
     flat = self.compare.variant_imports.where( :scu => item[0]).pluck("pric_flat").first
     qo = self.compare.variant_imports.where( :scu => item[0]).pluck("quantity").first
     e_variants << EditVariant.create_new(item[0],orig,flat,qo,self,nil)
   end
   EditVariant.import e_variants
 end
 
 def add_new_offers(no)

    no.each_slice(4) do |slice|
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
                  new_pictures << NewPicture.create_new(item,nil,pi.url,self,no)
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
         new_offers.clear
         edit_offers.clear
         edit_variants.clear
         new_pictures.clear
    end
 end
 def add_old_offers(oo)
      old_offers=[]
      oo.each do |item|
        off_id = self.compare.offers.where(:scu => item).pluck(:original_id).first
        old_offers<< OldOffer.create_new(item,off_id)
        old_offers.last.result =self
      end
      OldOffer.import old_offers
 end
 
 def add_new_collections(nc)
    nc.sort!
    new_collections=[]
    nc.each do |item|
      parent_flat = item.split(';')
      title = parent_flat.pop
      parent_flat =parent_flat.join(';')
      parent = self.compare.collections.find_by flat: parent_flat
      if item ==  title
          state="listing"
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
    nc.sort!.reverse!

    old_collections=[]
    nc.each do |item|
      current = self.compare.collections.find_by flat: item 
      parent_new =self.old_collections.where("collection_flat LIKE ?", "%#{item}%").first
      puts parent_new.try(:attributes)
      if parent_new
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
              if col_id
                state="listing"    
              else
                state="waiting" 
              end
              new_col_id = self.new_collections.where(:collection_flat => item[1]).first if col_id.none?
              off_id = self.compare.offers.where(:scu => item[0]).pluck(:original_id)
              new_collects << NewCollect.create_new( item, col_id.first, off_id.first, new_col_id,state )
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
  
  
end
