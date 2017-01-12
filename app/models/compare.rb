
include ComparesHelper
require 'benchmark'


class Compare < ActiveRecord::Base
    belongs_to :site
    has_many :offers, dependent: :destroy
    has_many :collections, dependent: :destroy
    has_many :collects, dependent: :destroy
    has_many :collect_imports, dependent: :destroy
    has_many :variant_imports, dependent: :destroy
    has_many :offer_imports, dependent: :destroy
    has_one :result, dependent: :destroy
    has_many :properties, dependent: :destroy
    
#    before_save :getData
    
#    module Helpers
#        extend ActionView::Helpers::ComparesHelper
#    end
    
    def compareData
        self.result = Result.new

        new_collections,old_collections = compare_collections
        self.result.add_new_collections(new_collections)
        self.result.add_old_collections(old_collections)
        new_collects, old_collects = compare_collects
        self.result.add_new_collects(new_collects)
        self.result.add_old_collects(old_collects)
        new_offers, old_offers = compare_offers_simple
        self.result.add_new_offers (new_offers)
        self.result.add_old_offers (old_offers)
        
        edited_images = compare_images(old_offers)
        
        self.result.add_new_images (edited_images)
        self.result.add_old_images (edited_images)
        
        edited_offers = compare_offers_props (old_offers)
        self.result.add_edit_offers (edited_offers)
        edited_variants = compare_variants (old_offers)
        self.result.add_edit_variants (edited_variants)
        self.name= self.name + DateTime.now.to_formatted_s(:long) if self.name
        
    end
    
    def compare_offers_simple
        imported = self.collect_imports.pluck("scu").uniq
        current = self.offers.pluck("scu")
        new_offers = imported-current
        old_offers = current - imported
        puts "new offers " + new_offers.count.to_s
        puts "_____________"
        puts "old offers " + old_offers.count.to_s
        return new_offers, old_offers
    end
    def compare_offers_props (old_offers)
        imported = self.offer_imports.pluck("scu","title","prop_flat").uniq
        current=[]
        self.offers.each do |o|  
#            flat = o.characteristics.includes(:property).pluck(
#            "properties.title,
 #           characteristics.title").to_h.values_at(*site_offer_order)
#            o.flat = flat.join(";")
            o.save
            current.push ( [o.scu,o.title,o.flat] ) if not old_offers.include? o.scu 
        end
        edited_offers = current- imported
        puts "edited offers " + edited_offers.count.to_s
        
        return edited_offers
    end
    def compare_variants (old_offers)
        imported = self.variant_imports.pluck("scu","quantity","pric_flat").uniq
        current=[]
        self.offers.each do |o|  
            var = o.variants.first

            current.push ( [o.scu, var.quantity, var.flat] ) if not old_offers.include? o.scu 
        end
        edited_variants = current- imported
        puts "edited_variants " +edited_variants.count.to_s
        
        return edited_variants
        
    end
    def compare_images (old_offers)
        imported = self.offer_imports.pluck("scu","image_status").uniq
        current=[]
        self.offers.each do |o|  
            
            current.push ( [o.scu,o.image_status] ) if not old_offers.include? o.scu 
        end
        edited_pictures = current- imported
        puts "edited_variants " +edited_pictures.count.to_s
        
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
        #  properties_hash = self.site.get_Properties_from_insales
        #  if properties_hash
        #      getProperties(properties_hash)
        #  end
        #  properties_hash=nil
        #  collections_hash = self.site.get_Collections_from_insales
        #  if collections_hash
        #      getCollections(collections_hash)
        #  end
        # #  offers_hash = get_Offers_from_insales_marketplace
        # #  if offers_hash
        # #      getOffers_marketplace(offers_hash) 
        # #  end
        # collections_hash=nil
        # GC.start
        #  self.site.get_Offers_from_insales_products(self)
        #  puts "offers"
        #  puts self.offers.size
         
        #  self.site.get_Collects_from_insales(self)
        #  puts "collects"
        #  puts self.collects.size
        import_csv = self.site.get_import_from_odin_ass()
        get_import( import_csv ) if import_csv
        puts import_csv.size
        self.name= self.name + DateTime.now.to_formatted_s(:long) if self.name
    
    end
    
    def get_import(csv)
        puts "csv"
        puts csv.size
        import=[]
        offers = csv.values_at(*self.site.scu_field, 
                               *self.site.title_field, 
                               *self.site.sort_order,
                               *self.site.csv_images_order.split(","),
                               *self.site.csv_offer_order.split(",")).uniq
        offers.each do |o| 
            import << OfferImport.create_new(o,self)
        end
        OfferImport.import import, recursive: true
        import.clear
        variants = csv.values_at(*self.site.scu_field,
                                 *self.site.quantity_field,
                                 *self.site.csv_variant_order.split(",")).uniq
        variants.each do |v| 
            import << VariantImport.create_new(v,self)
        end
        VariantImport.import import
        import.clear
        collections = csv.values_at(*self.site.scu_field,
                                    *self.site.csv_collection_order.split(",")).uniq

        import = CollectImport.create_collects(collections,self)
        CollectImport.import import
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
       offers=[]
       ch=[]
       h.each { |a| 
           o = self.offers.new()
           ch += o.new_from_hash_products(a, self.properties)
           o.compare=self
           offers << o
       }
       Offer.import offers , recursive: true
       
       ch.each do |c|
           c.run_callbacks(:save) { false }
       end
       Characteristic.import ch
       
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
