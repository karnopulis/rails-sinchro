class Outsale < ApplicationRecord
    def self.add_Collections_to_outsales(collections,url,site_login,site_pass)
        message = ApplicationController.new.view_context.render( :partial => "outsales/add_collection.json.jbuilder", :locals => {:new_collections =>  collections})
        
        # response = post_to_url_json(URI("http://"+url+"/admin/"+"collections_group_create.json"),message , site_login, site_pass)
        # return response
    end
    def self.add_Products_to_outsales(products,url,site_login,site_pass)
        message = ApplicationController.new.view_context.render( :partial => "outsales/add_product.json.jbuilder", :locals => {:new_offers =>  products})
        
#        response = post_to_url_json(URI("http://"+self.url+"/admin/"+"products_group_create.json"),message , self.site_login, self.site_pass)
#        return response
    end
    def add_Collect_to_outsales(collects,url,site_login,site_pass)
        message = ApplicationController.new.view_context.render( :partial => "outsales/add_collect.json.jbuilder", :locals => {:new_collects => collects})
        
        #response = post_to_url_json(URI("http://"+self.url+"/admin/"+"collects_group_create.json"),message , self.site_login, self.site_pass)
        #return response
    end
    def add_Picture_to_insales(image)
        message = ApplicationController.new.view_context.render( :partial => "insales/add_image.json.jbuilder", :locals => {:new_image =>  image})
        
        response = post_to_url_json(URI("http://"+self.url+"/admin/"+"products/"+image.original_offer_id+"/images.json"),message , self.site_login, self.site_pass)
        return response
    end
    def self.edit_Products_to_outsales(products,url,site_login,site_pass)
        message = ApplicationController.new.view_context.render( :partial => "outsales/edit_product.json.jbuilder", :locals => {:edit_offers =>  products})

#        response = put_to_url_json(URI("http://"+self.url+"/admin/"+"products/"+product.original_id.to_s+".json"),message , self.site_login, self.site_pass)
#        return response
    end
    def edit_Collection_to_insales(collection)
        message = ApplicationController.new.view_context.render( :partial => "insales/edit_collection.json.jbuilder", :locals => {:edit_collection =>  collection})

        response = put_to_url_json(URI("http://"+self.url+"/admin/"+"collections/"+collection.collection_original_id.to_s+".json"),message , self.site_login, self.site_pass)
        return response
    end
    def self.edit_Variants_to_outsales(variants,url,site_login,site_pass)
        message = ApplicationController.new.view_context.render( :partial => "outsales/edit_variants.json.jbuilder", :locals => {:edit_variants =>  variants})

        # response = put_to_url_json(URI("http://"+self.url+"/admin/"+"products/"+"variants_group_update.json"),message , self.site_login, self.site_pass)
        # return response
    end
     def delete_Product_from_insales(product)
    
        response = delete_url_json( URI("http://"+self.url+"/admin/"+"products/"+product.original_id.to_s+".json"), self.site_login, self.site_pass)
        return response
    end
     def delete_Picture_from_insales(image)
    
        response = delete_url_json( URI("http://"+self.url+"/admin/"+"products/"+image.original_offer_id.to_s+"/images/"+image.original_id.to_s+".json"), self.site_login, self.site_pass)
        return response
    end
    def delete_Collection_from_insales(collection)
    
        response = delete_url_json( URI("http://"+self.url+"/admin/"+"collections/"+collection.collection_original_id.to_s+".json"), self.site_login, self.site_pass)
        return response
    end
        def delete_Collect_from_insales(collect)
    
        response = delete_url_json( URI("http://"+self.url+"/admin/"+"collects/"+collect.collect_original_id.to_s+".json"), self.site_login, self.site_pass)
        return response
    end
    
end
