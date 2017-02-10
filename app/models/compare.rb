
include ComparesHelper
require 'benchmark'


class Compare < ApplicationRecord
    belongs_to :site
    has_many :offers, dependent: :destroy
    has_many :variants, dependent: :destroy

    has_many :collections, dependent: :destroy
    has_many :collects, dependent: :destroy
    has_many :collect_imports, dependent: :destroy
    has_many :variant_imports, dependent: :destroy
    has_many :offer_imports, dependent: :destroy
    has_one :result, dependent: :destroy
    has_many :properties, dependent: :destroy
    
    has_many :status_trackers , dependent: :destroy
#    before_save :getData
    
#    module Helpers
#        extend ActionView::Helpers::ComparesHelper
#    end
    def to_json
        puts self.attributes
        ApplicationController.new.view_context.render( template: "compares/show.json.jbuilder", locals: {"compare" =>  self})
#           ,
# #          locals: { self.class.model_name.element => self },
#           formats: [:json],
#           handlers: [:jbuilder]
        # )
    end
    def compareData
        
        self.result = Result.new
        self.save
        self.status_trackers.add("INFO","Cтарт процесса сравнения ")

        new_collections,old_collections = compare_collections
        self.result.add_new_collections(new_collections)
        self.result.add_old_collections(old_collections)
        new_offers, old_offers, old_offers_ids = compare_offers_simple
        self.result.add_new_offers(new_offers)
        self.result.add_old_offers(old_offers, old_offers_ids)
        new_collects, old_collects = compare_collects
        self.result.add_new_collects(new_collects)
        self.result.add_old_collects(old_collects)
        edited_offers = compare_offers_props (old_offers_ids)
        self.result.add_edit_offers (edited_offers)
        edited_variants = compare_variants (old_offers_ids)
        self.result.add_edit_variants (edited_variants)
    
         edited_images = compare_images(old_offers_ids)
    
         self.result.add_new_images (edited_images)
         self.result.add_old_images (edited_images)
        
        
        # puts self.name
        self.name= self.name + " "+ Time.now.to_formatted_s(:time) if self.name
        self.save
        self.status_trackers.add("INFO","Окончание процесса сравнения ")
    end
    
    def compare_offers_simple
        imported = self.offer_imports.pluck("scu").uniq
        current = self.offers.pluck("scu")
        
        new_offers = imported-current
        old_offers = current - imported
        old_offers_ids= self.offers.where(:scu=> old_offers).pluck("original_id")
        dubs= current.find_all { |e| current.count(e) > 1 }
        dubs.uniq.each do |d|
            old_offers_ids<< self.offers.where(:scu => d).pluck("original_id").drop(1)
        end
        puts "new offers " + new_offers.count.to_s
        puts "_____________"
        puts "old offers " + old_offers.count.to_s
        return new_offers, old_offers, old_offers_ids.flatten
    end
    def compare_offers_props (old_offers)
        imported = self.offer_imports.pluck("scu","title","sort_order","prop_flat").uniq
        # current=[]
        current = self.offers.where.not(:original_id => old_offers).pluck("scu","title","sort_weight","flat").uniq
#         self.offers.each do |o|  
# #            flat = o.characteristics.includes(:property).pluck(
# #            "properties.title,
#  #           characteristics.title").to_h.values_at(*site_offer_order)
# #            o.flat = flat.join(";")
#             current.push ( [o.scu,o.title,o.sort_weight,o.flat] ) if not old_offers.include? o.original_id 
#         end
        edited_offers = current- imported
        puts "edited offers " + edited_offers.count.to_s
        
        return edited_offers
    end
    def compare_variants (old_offers)
        imported = self.variant_imports.pluck("scu","quantity","pric_flat").uniq
        puts "self.variants"
        puts self.variants.size
        current = self.variants.includes(:offer).where.not("offers.original_id" =>old_offers).pluck("variants.sku","variants.quantity","variants.flat").uniq
        
        # current=[]
        # self.offers.each do |o|  
        #     var = o.variants.first
        #     begin
        #     current.push ( [o.scu, var.quantity, var.flat] ) if not old_offers.include? o.scu 
        #     rescue Exception => exc
        #         puts o.scu
        #     end
        # end
        edited_variants = current- imported
        puts "edited_variants " +edited_variants.count.to_s
        
        return edited_variants
        
    end
    def compare_images (old_offers)
        imported = self.offer_imports.pluck("scu","image_status").uniq
        current=[]
        self.offers.each do |o|  
            
            current.push ( [o.scu,o.image_status] ) if not old_offers.include? o.original_id 
        end
        edited_pictures = current- imported
        puts "edited_images " +edited_pictures.count.to_s
        
        return edited_pictures
        
    end
    def compare_collections
        imported = self.collect_imports.pluck("flat").uniq
        current = self.collections.pluck("flat")
        new_collections = imported-current
        old_collections = current-imported
        puts "new_collections: " + new_collections.count.to_s
        puts "old_collections: " + old_collections.count.to_s
        puts "___________"
        return new_collections, old_collections
    end
    
    def compare_collects
        imported = self.collect_imports.pluck("scu","flat").uniq
        current =self.collects.includes(:collection,:offer).pluck("offers.scu","collections.flat")
        new_collects = imported-current
        old_collects = current-imported
        puts "new_collects: " + new_collects.count.to_s
        puts "old_collects: " + old_collects.count.to_s
        puts "_____________"
        return new_collects, old_collects
    end
    
    
    def getData
         puts self.name
         self.name= self.name + DateTime.now.to_formatted_s(:long) if self.name
         self.save
         pid = Spawnling.new do
            self.status_trackers.add("INFO","1с FTP старт процесса загрузки")
            import_csv = self.site.get_import_from_odin_ass()
            get_import( import_csv ) if import_csv
            puts import_csv.size if import_csv
            self.status_trackers.add("INFO","1с FTP окончание процесса загрузки")
         end 
         self.status_trackers.add("INFO","Insales старт процесса загрузки")
         categories_hash = self.site.get_Categories_from_insales
         if categories_hash
             getLastCategory(categories_hash)
         end
         self.status_trackers.add("INFO","Insales Категорий загружено: "+categories_hash.size.to_s)
         properties_hash = self.site.get_Properties_from_insales
         if properties_hash
             getProperties(properties_hash)
         end
         self.status_trackers.add("INFO","Insales Параметров товаров  загружено: "+properties_hash.size.to_s)

         properties_hash=nil
         collections_hash = self.site.get_Collections_from_insales
         if collections_hash
             getCollections(collections_hash)
         end
         self.status_trackers.add("INFO","Insales Рубрик загружено: "+collections_hash.size.to_s)
        # #  offers_hash = get_Offers_from_insales_marketplace
        # #  if offers_hash
        # #      getOffers_marketplace(offers_hash) 
        # #  end
        collections_hash=nil
        GC.start
         self.site.get_Offers_from_insales_products(self)
         puts "offers"
         puts self.offers.size
         self.status_trackers.add("INFO","Insales Товаров загружено: "+self.offers.size.to_s)
         self.site.get_Collects_from_insales(self)
         puts "collects"
         puts self.collects.size
         self.status_trackers.add("INFO","Insales Размещений продуктов загружено: "+self.collects.size.to_s)
         
        Spawnling.wait(pid)
        self.name= self.name + " "+ Time.now.to_formatted_s(:time) if self.name
        self.save
        self.status_trackers.add("INFO","Insales окончание процесса загрузки")
    
    end
    
    def get_import(csv)
        puts "csv"
        puts csv.size
        import=[]
        p_import=[]
        offers = csv.values_at(*self.site.scu_field, 
                              *self.site.title_field, 
                              *self.site.sort_order,
                              *self.site.csv_images_order.split(","),
                              *self.site.csv_offer_order.split(",")).uniq
        offers.each do |o| 
            oi,pi = OfferImport.create_new(o,self)
            import << oi
            p_import= p_import+pi
        end
        OfferImport.import import
        self.status_trackers.add("INFO","1с FTP Товаров загружено: "+import.size.to_s)
         keys= import.map(&:scu)
         no_ids = OfferImport.where(:compare=>self,:scu=>keys).pluck(:scu,:id).to_h
         p_import.each { |n| n.offer_import_id= no_ids[n.scu] }
         
        PictureImport.import p_import
        self.status_trackers.add("INFO","1с FTP Ссылок изображений загружено: "+p_import.size.to_s)
        import.clear
        p_import.clear
        variants = csv.values_at(*self.site.scu_field,
                                 *self.site.quantity_field,
                                 *self.site.csv_variant_order.split(",")).uniq
        variants.each do |v| 
            import << VariantImport.create_new(v,self)
        end
        VariantImport.import import
        self.status_trackers.add("INFO","1с FTP Свойств товаров загружено: "+import.size.to_s)
        import.clear
        collections = csv.values_at(*self.site.scu_field,
                                    *self.site.csv_collection_order.split(",")).uniq

        import = CollectImport.create_collects(collections,self)
        CollectImport.import import
        self.status_trackers.add("INFO","1с FTP Размещений товаров загружено: "+import.size.to_s)
        import.clear

    end

    def getOffers_marketplace(h)
#      h= Hash.from_xml(File.open("24025.xml"))
#       h=hash["yml_catalog"]["shop"]["offers"]["offer"]
        puts "offers"
        puts h.size
       h.each { |a| 
           o = Offer.new()
           o.new_from_hash_marketplace (a)
           self.offers << o
       }
   end
    def getOffers_products(h)
        h.each_slice(400) do |slice|
            offers=[]
            characteristics=[]
            variants=[]
            pictures=[]
            prices=[]
            slice.each do |item|
  
                   o = Offer.new()
                   o.compare=self

                   var,pic,ch,pr = o.new_from_hash_products(item, self.properties)
                   variants=variants+var
                   pictures=pictures+pic
                   characteristics=characteristics+ch
                   prices=prices+pr
                   offers << o
      
            end
            Offer.import offers
            
            keys= offers.map(&:scu)
            no_ids = Offer.where(:compare=>self,:scu=>keys).pluck(:scu,:id).to_h
            characteristics.each { |n| n.offer_id= no_ids[n.scu] }
            Characteristic.import characteristics
            pictures.each { |n| n.offer_id= no_ids[n.scu] }
            Picture.import pictures
            variants.each { |n| n.offer_id= no_ids[n.sku] }
            Variant.import variants
            keys= variants.map(&:sku)
            no_ids = Variant.where(:compare=>self,:sku=>keys).pluck(:sku,:id).to_h
            prices.each { |n| n.variant_id= no_ids[n.sku] }
            Price.import prices
            offers.clear
            characteristics.clear
            variants.clear
            pictures.clear
            prices.clear
       end
    end
    def getLastCategory(h)
        self.category_original_id = h.pluck("id").max
        self.save
    end
    def getProperties(h)
        puts "properties"
        puts h.size
        pr=[]
        h.each { |a| 
            o=Property.new
            o = o.new_from_hash (a)
            o.compare=self
            pr << o
        }
        Property.import pr
    end
    def getCollections(h)
#       h=hash["collections"]
        puts "collections"
        puts h.size
       o=Collection.new
       o = o.new_from_hash(h,self.site.site_global_parent,self.id)
       Collection.import o
       
    end
    def getCollects(h)
    #    self.save
 ##На маркетплейс невыгружается товар без остатков. 
 ##отключи на сайте галочку не показывать товар при нудевых остатках       
        puts "collects"
        puts h.size
        Collect.bulk_insert do |worker|
            worker.set_size = 500
            h.each do |a| 
                offer_id = a["product_id"].to_i
                collection_id= a["collection_id"].to_i
            
                collection_index = self.collections.index{ |b|  b.original_id == collection_id }
                offer_index = self.offers.index{ |c|  c.original_id == offer_id }
    
                if ( !collection_index )
                    puts "Error not existing or duplicate collection"
                    puts collection_id
                    puts a["id"]
                    next
                end
                if ( !offer_index )
                    puts "Error not existing or duplicate offer"  
                    puts offer_id
                    puts a["id"]
                    next
                end
    #            self.collections[collection_index].offers << self.offers[offer_index]
    #            self.collections[collection_index].collects.last.original_id = a["id"].to_i
    #            self.collects << self.collections[collection_index].collects.last
                 worker.add( {"original_id" => a["id"].to_i, 
                              "collection_id" => self.collections[collection_index].id, 
                              "offer_id" => self.offers[offer_index].id,
                              "compare_id"=>self.id })
            end
        end
       h=nil
    end
    
end
