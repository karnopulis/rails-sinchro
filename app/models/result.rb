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
  
 def add_new_images (edited_images)
   new_pictures=[]
   edited_images.each do |e| 
     poid= self.compare.offers.where(:scu => e[0]).first.original_id
     imgs= self.compare.offer_imports.where(:scu => e[0]).first.picture_imports
     imgs.each do |pi|
        new_pictures << NewPicture.create_new(e[0],poid,pi.url)
        new_pictures.last.result=self
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
     e_offers << EditOffer.create_new(item[0],orig,flat,name)
     e_offers.last.result=self
   end
   EditOffer.import e_offers
 end
 
 def add_edit_variants (edited_variants)
   e_variants=[]
    edited_variants.each do |item|
     orig = self.compare.offers.where( :scu => item[0]).first.variants.pluck("original_id").first
     flat = self.compare.variant_imports.where( :scu => item[0]).pluck("pric_flat").first
     qo = self.compare.variant_imports.where( :scu => item[0]).pluck("quantity").first
     e_variants << EditVariant.create_new(item[0],orig,flat,qo)
     e_variants.last.result=self
   end
   EditVariant.import e_variants
 end
 
 def add_new_offers(no)
   new_offers=[]
     no.each do |item|
#       off_import = self.compare.offer_imports.where(:scu => item).first
#       var_import = self.compare.variant_imports.where(:scu => item).first
        off_import = self.compare.offer_imports.find_by scu: item
        var_import = self.compare.variant_imports.find_by scu: item
#       pic_import = self.compare.picture_imports.where(:scu => item).first
       no =NewOffer.create_new(item)
       no.edit_offers << EditOffer.create_new(item,nil,off_import.prop_flat,off_import.title)
       no.edit_offers.last.result=self
       no.edit_variants << EditVariant.create_new(item,nil,var_import.pric_flat,var_import.quantity)
       no.edit_variants.last.result=self
       off_import.picture_imports.each do |pi|
           no.new_pictures << NewPicture.create_new(item,nil,pi.url)
           no.new_pictures.last.result=self
       end
       new_offers<< no
       new_offers.last.result=self
     end
     NewOffer.import new_offers, recursive: true
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
      par_id_from_cur = self.compare.collections.where(:flat => parent_flat ).pluck(:original_id)
      par_from_new = self.new_collections.where(:collection_flat => parent_flat).first if par_id_from_cur.none?
      self.new_collections << NewCollection.create_new(item,par_id_from_cur,par_from_new,title)
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
      cur_id = self.compare.collections.where(:flat => item ).pluck(:original_id)
      parent_flat = item.split(';')
      parent_flat.pop
      parent_flat =parent_flat.join(';')
      par_from_new = self.old_collections.where(:collection_flat => parent_flat).first

      old_collections << OldCollection.create_new(item,cur_id.first,par_from_new)
      old_collections.last.result=self
    end
    OldCollection.import old_collections
#    self.old_collections << old_collections
  end
  
  def add_new_collects(nc)
    new_collects=[]
    nc.each do |item|
      col_id = self.compare.collections.where(:flat => item[1]).pluck(:original_id)
      new_col_id = self.new_collections.where(:collection_flat => item[1]).first if col_id.none?
      off_id = self.compare.offers.where(:scu => item[0]).pluck(:original_id)
      new_collects << NewCollect.create_new( item, col_id.first, off_id.first, new_col_id )
      new_collects.last.result=self
    end
    NewCollect.import new_collects
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
