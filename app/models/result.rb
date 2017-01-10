class Result < ActiveRecord::Base
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
   edited_images.each do |e| 
     poid= self.compare.offers.where(:scu => e[0]).first.original_id
     imgs= self.compare.offer_imports.where(:scu => e[0]).first.picture_imports
     imgs.each do |pi|
        self.new_pictures << NewPicture.create_new(e[0],poid,pi.url)
     end
   end
   
 end
 
 def add_old_images (edited_images)
   edited_images.each do |e|
    self.compare.offers.where("scu" => e[0]).first.pictures.each do |p|
      self.old_pictures << OldPicture.create_new(e[0],p.original_id)
    end
   end
   
 end
  
 def add_edit_offers (edited_offers)
   
   edited_offers.each do |item|
     orig = self.compare.offers.where( :scu => item[0]).pluck("original_id").first
     flat = self.compare.offer_imports.where( :scu => item[0]).pluck("prop_flat").first
     name = self.compare.offer_imports.where( :scu => item[0]).pluck("title").first
     self.edit_offers << EditOffer.create_new(item[0],orig,flat,name)
   end
 end
 
 def add_edit_variants (edited_variants)
    edited_variants.each do |item|
     orig = self.compare.offers.where( :scu => item[0]).first.variants.pluck("original_id").first
     flat = self.compare.variant_imports.where( :scu => item[0]).pluck("pric_flat").first
     qo = self.compare.variant_imports.where( :scu => item[0]).pluck("quantity").first
     self.edit_variants << EditVariant.create_new(item[0],orig,flat,qo)
   end
 end
 
 def add_new_offers(no)
     no.each do |item|
       off_import = self.compare.offer_imports.where(:scu => item).first
       var_import = self.compare.variant_imports.where(:scu => item).first
       no =NewOffer.create_new(item)
       no.edit_offers << EditOffer.create_new(item,nil,off_import.prop_flat,off_import.title)
       no.edit_variants << EditVariant.create_new(item,nil,var_import.pric_flat,var_import.quantity)
       self.new_offers<< no
     end
 end
 def add_old_offers(oo)
      oo.each do |item|
        off_id = self.compare.offers.where(:scu => item).pluck(:original_id).first
        self.old_offers<< OldOffer.create_new(item,off_id)
      end
 end
 
 def add_new_collections(nc)
    nc.sort!
    nc.each do |item|
      parent_flat = item.split(';')
      title = parent_flat.pop
      parent_flat =parent_flat.join(';')
      par_id_from_cur = self.compare.collections.where(:flat => parent_flat ).pluck(:original_id)
      par_from_new = self.new_collections.where(:collection_flat => parent_flat).first if par_id_from_cur.none?
      self.new_collections << NewCollection.create_new(item,par_id_from_cur,par_from_new,title)
    end
      
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
    OldCollection.bulk_insert do |worker|
      old_collections.each do |attrs|
      worker.add(attrs.attributes.except('created_at','updated_at'))
      end
    end
#    self.old_collections << old_collections
  end
  
  def add_new_collects(nc)
    nc.each do |item|
      col_id = self.compare.collections.where(:flat => item[1]).pluck(:original_id)
      new_col_id = self.new_collections.where(:collection_flat => item[1]).first if col_id.none?
      off_id = self.compare.offers.where(:scu => item[0]).pluck(:original_id)
      self.new_collects << NewCollect.create_new( item, col_id.first, off_id.first, new_col_id )
    end
  end
  
  def add_old_collects(oc)
    oc.each do |item|
      col_id = self.compare.collects.includes(:collection,:offer).where("collections.flat=? and offers.scu=?",
               item[1],item[0]).references(:collection,:offer).pluck("collects.original_id")
      self.old_collects << OldCollect.create_new(item,col_id.first)
    end
  end
  
  
end
