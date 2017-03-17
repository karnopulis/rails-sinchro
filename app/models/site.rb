require 'net/ftp'

class Site < ApplicationRecord
    has_many :compares, dependent: :destroy
    
    def self.dev_init
        YAML.load_file("sites.yaml").each { |v|self.create!(v.attributes)}
    end
    def self.dev_dump
        File.open("sites.yaml","w"){ |f| f.write(Site.all.to_yaml) }   
    end
    def self.users_dump
        File.open("users.yaml","w"){ |f| f.write(User.all.to_yaml) }   
    end
    def self.users_init
        YAML.load_file("users.yaml").each { |v| User.new(v.attributes).save( :validate => false)}   
    end
    
    def add_Collection_to_insales(collection)
        message = ApplicationController.new.view_context.render( :partial => "insales/add_collection.json.jbuilder", :locals => {:new_collection =>  collection})
        
        response = post_to_url_json(URI("http://"+self.url+"/admin/"+"collections.json"),message , self.site_login, self.site_pass)
        # response={:id=>Random.new.rand(1..10000000),:status=>Random.new.rand(1..10)<4 ? "error" : "ok"}
        # if response[:status]=="error" 
        #     response[:error] ="err" 
        # end
        return response
    end
    def add_Product_to_insales(product)
        message = ApplicationController.new.view_context.render( :partial => "insales/add_product.json.jbuilder", :locals => {:new_offer =>  product})
        
        response = post_to_url_json(URI("http://"+self.url+"/admin/"+"products.json"),message , self.site_login, self.site_pass)
        # response={:id=>Random.new.rand(1..10000000),:variants=>{:id=>Random.new.rand(1..10000000)},:status=>Random.new.rand(1..10)<4 ? "error" : "ok"}
        # if response[:status]=="error" 
        #     response[:error] ="err" 
        # end
        return response
    end
    def add_Collect_to_insales(collect)
        message = ApplicationController.new.view_context.render( :partial => "insales/add_collect.json.jbuilder", :locals => {:new_collect => collect})
        
        response = post_to_url_json(URI("http://"+self.url+"/admin/"+"collects.json"),message , self.site_login, self.site_pass)
        # response={:id=>Random.new.rand(1..10000000),:status=>Random.new.rand(1..10)<4 ? "error" : "ok"}
        # if response[:status]=="error" 
        #     response[:error] ="err" 
        # end
        return response
    end
    def add_Picture_to_insales(image)
        message = ApplicationController.new.view_context.render( :partial => "insales/add_image.json.jbuilder", :locals => {:new_image =>  image})
        
        response = post_to_url_json(URI("http://"+self.url+"/admin/"+"products/"+image.original_offer_id+"/images.json"),message , self.site_login, self.site_pass)
        # response={:id=>Random.new.rand(1..10000000),:status=>Random.new.rand(1..10)<4 ? "error" : "ok"}
        # if response[:status]=="error" 
        #     response[:error] ="err" 
        # end
        return response
    end
    def edit_Product_to_insales(product)
        message = ApplicationController.new.view_context.render( :partial => "insales/edit_product.json.jbuilder", :locals => {:edit_offer =>  product})
        response = put_to_url_json(URI("http://"+self.url+"/admin/"+"products/"+product.original_id.to_s+".json"),message , self.site_login, self.site_pass)
        # response={:id=>Random.new.rand(1..10000000),:status=>Random.new.rand(1..10)<4 ? "error" : "ok"}
        # if response[:status]=="error" 
        #     response[:error] ="err" 
        # end
        return response
    end
    def edit_collection_to_insales(collection)
        puts collection.original_id
        puts "http://"+self.url+"/admin/"+"collections/"+collection.original_id.to_s+".json"
        message = ApplicationController.new.view_context.render( :partial => "insales/edit_collection.json.jbuilder", :locals => {:edit_collection =>  collection})

        response = put_to_url_json(URI("http://"+self.url+"/admin/"+"collections/"+collection.original_id.to_s+".json"),message , self.site_login, self.site_pass)
        
        return response
    end
    def edit_Variants_to_insales(variants)
        
        message = ApplicationController.new.view_context.render( :partial => "insales/edit_variants.json.jbuilder", :locals => {:edit_variants =>  variants})

       response = put_to_url_json(URI("http://"+self.url+"/admin/"+"products/"+"variants_group_update.json"),message , self.site_login, self.site_pass)
        # f=[]
        # variants.each  { |v|  f << {"id"=>v.original_id,"status"=>Random.new.rand(1..10)<4 ? "error" : "ok"} }
        # return f
        return response
    end
     def delete_Product_from_insales(product)
#        puts "http://"+self.url+"/admin/"+"products/"+product.original_id.to_s+".json"
        response = delete_url_json( URI("http://"+self.url+"/admin/"+"products/"+product.original_id.to_s+".json"), self.site_login, self.site_pass)
        # response={:id=>Random.new.rand(1..10000000),:status=>Random.new.rand(1..10)<4 ? "error" : "ok"}
        # if response[:status]=="error" 
        #     response[:error] ="err" 
        # end        
        return response
    end
     def delete_Picture_from_insales(image)
    
        response = delete_url_json( URI("http://"+self.url+"/admin/"+"products/"+image.original_offer_id.to_s+"/images/"+image.original_id.to_s+".json"), self.site_login, self.site_pass)
        # response={:id=>Random.new.rand(1..10000000),:status=>Random.new.rand(1..10)<4 ? "error" : "ok"}
        # if response[:status]=="error" 
        #     response[:error] ="err" 
        # end
        return response
    end
    def delete_Collection_from_insales(collection)
    
        response = delete_url_json( URI("http://"+self.url+"/admin/"+"collections/"+collection.collection_original_id.to_s+".json"), self.site_login, self.site_pass)
        # response={:id=>Random.new.rand(1..10000000),:status=>Random.new.rand(1..10)<4 ? "error" : "ok"}
        # if response[:status]=="error" 
        #     response[:error] ="err" 
        # end
        return response
    end
        def delete_Collect_from_insales(collect)
    
        response = delete_url_json( URI("http://"+self.url+"/admin/"+"collects/"+collect.collect_original_id.to_s+".json"), self.site_login, self.site_pass)
        # response={:id=>Random.new.rand(1..10000000),:status=>Random.new.rand(1..10)<4 ? "error" : "ok"}
        # if response[:status]=="error" 
        #     response[:error] ="err" 
        # end
        return response
    end
    def get_Collections_from_insales
        response = get_from_url( URI("http://"+self.url+"/admin/"+"collections.xml"), self.site_login, self.site_pass)
        response["collections"]
    end
    def get_Properties_from_insales
        response = get_from_url( URI("http://"+self.url+"/admin/"+"properties.xml"), self.site_login, self.site_pass)
        response["properties"]
    end
    def get_Categories_from_insales
        response = get_from_url( URI("http://"+self.url+"/admin/"+"categories.xml"), self.site_login, self.site_pass)
        response["categories"]
    end
    def get_Offers_from_insales_marketplace
        response = get_from_url( URI("http://"+self.url+"/marketplace/24025.xml"), self.site_login, self.site_pass) #gk
#        response = get_from_url( URI("http://"+url+"/marketplace/26603.xml"), insales_id, insales_key) #rostov
        response["yml_catalog"]["shop"]["offers"]["offer"]
    end
    def get_Offers_from_insales_products(compare)
        response = get_from_insales_page( "http://"+self.url+"/admin/"+"products.xml?per_page=250&", "products", compare )
        #File.open("products.xml", "w") { |file| file.write response.to_xml}
         #response= Hash.from_xml(File.open("products.xml"))
         #response=h["products"]
         return response
    end
    def get_Collects_from_insales(compare)
        response = get_from_insales_page( "http://"+self.url+"/admin/"+"collects.xml?", "collects",compare)
    end
    
    def get_import_from_odin_ass
        response = get_csv_from_ftp( self.home_ftp, self.home_file_name,  self.home_login, self.home_pass)
#        response = get_csv_from_url( URI("http://"+'94.141.184.178:5080'+"/ftp/site.csv"), home_login, home_pass)
    end
        
    def get_from_insales_page(uri,model,compare)
        i=1
#        h=[]
        loop do
            uri_page = ( URI (uri + "page="+i.to_s ) )
#            get_Collections_from_insales
            
            r = get_from_url(uri_page, self.site_login, self.site_pass)

            puts uri_page.to_s
            break if r == nil
 #           File.open("products"+i.to_s+".xml", "w") { |file| file.write r.to_xml}
            case model
            when "products"
                compare.getOffers_products(r[model])
                r=nil
                 GC.start
            when "collects"    
                compare.getCollects(r[model])
                r=nil
                 GC.start
            end    
#            h=h + r[model]
            i+=1
#            puts h.class
        end
#        return h
    end
    def delete_url_json(uri,id,key )
        req  = Net::HTTP::Delete.new(uri.request_uri)
        req.basic_auth id,key
        req.content_type="application/json"
#        req.body=message
#        puts    req.body 
        begin
        resp = Net::HTTP.start(uri.hostname,uri.port) { |http|
            http.request(req)
            
        }
        rescue Exception => exc
            puts exc.message
            return {:status=>"error",:error=>exc.message}
        end
        r = resp.get_fields("api-usage-limit")
        if r
            r= r[0].split('/')
            puts resp.get_fields("api-usage-limit").to_s
            puts r[0].to_i
        end
        puts resp
        case resp
        when Net::HTTPOK
            puts (resp.code + " " + resp.message)
            # h=JSON.parse(resp.body)
            # puts h
            return {:status =>"ok"}
            # if h["nil_classes"]
            #     return nil
            # else
            #     return h
            # end
        when Net::HTTPClientError, Net::HTTPInternalServerError
            puts (resp.code + " " + resp.message)
            h=JSON.parse(resp.body)
            puts h
            return {:status=>"error",:error=>h.to_s}
            return nil
        end
    end
    def post_to_url_json(uri,message,id,key )
        req  = Net::HTTP::Post.new(uri.request_uri)
        req.basic_auth id,key
        req.content_type="application/json"
        req.body=message
        puts    req.body 
        begin
        resp = Net::HTTP.start(uri.hostname,uri.port) { |http|
            http.request(req)
            
        }
        rescue Exception => exc
            puts exc.message
            return {:status=>"error",:error=>exc.message}
        end
        r = resp.get_fields("api-usage-limit")
        if r
            r= r[0].split('/')
            puts resp.get_fields("api-usage-limit").to_s
            puts r[0].to_i
        end
        puts resp
        case resp
        when Net::HTTPCreated
            puts (resp.code + " " + resp.message)
            h=JSON.parse(resp.body)
            if h.class==Class::Array
                h
            else
                h[:status]="ok"
            end
#            puts h
            return h
            # if h["nil_classes"]
            #     return nil
            # else
            #     return h
            # end
        when Net::HTTPClientError, Net::HTTPInternalServerError
            puts (resp.code + " " + resp.message)
            h=JSON.parse(resp.body)
            puts h
            return {:status=>"error",:error=>h.to_s}
        end
    end
    def put_to_url_json(uri,message,id,key )
        req  = Net::HTTP::Put.new(uri.request_uri)
        req.basic_auth id,key
        req.content_type="application/json"
        req.body=message
        puts    req.body 
        begin
        resp = Net::HTTP.start(uri.hostname,uri.port) { |http|
            http.request(req)
            
        }
        rescue Exception => exc
            puts exc.message
            return {:status=>"error",:error=>exc.message}
        end
        r = resp.get_fields("api-usage-limit")
        if r
            r= r[0].split('/')
            puts resp.get_fields("api-usage-limit").to_s
            puts r[0].to_i
        end
        puts resp
        case resp
        when Net::HTTPOK
            puts (resp.code + " " + resp.message)
            h=JSON.parse(resp.body)
            # puts h
            # puts h.class
            if h.class==Class::Array
                h
            else
                h[:status]="ok"
            end
            puts h
            return h
            # if h["nil_classes"]
            #     return nil
            # else
            #     return h
            # end
        when Net::HTTPClientError, Net::HTTPInternalServerError
            puts (resp.code + " " + resp.message)
            h=JSON.parse(resp.body)
            puts h
            return {:status=>"error",:error=>h.to_s}
        end
    end
 
 
    def get_from_url (uri, id,key )
        req  = Net::HTTP::Get.new(uri.request_uri)
        req.basic_auth id,key
        puts "+++++++++++++++++++"
        begin
        resp = Net::HTTP.start(uri.hostname,uri.port) { |http|
            http.request(req)
            
        }
        rescue Exception => exc
             self.status_trackers.add("ERROR"+"Get from insales" +exc.message + uri.path)
            return nil
        end
        r = resp.get_fields("api-usage-limit")
        if r
            r= r[0].split('/')
            puts resp.get_fields("api-usage-limit").to_s
#            puts r[0].to_i
        end
        case resp
        when Net::HTTPOK
            h=Hash.from_xml(resp.body)
            
            if h["nil_classes"]
                return nil
            else
                return h
            end
        when Net::HTTPClientError, Net::HTTPInternalServerError
            puts (resp.code + resp.message)
            self.status_trackers.add("ERROR"+"Get from insales" +resp.code + resp.message+uri.path)
            return nil
        end
    end


    def get_csv_from_url (uri, id,key )
        req  = Net::HTTP::Get.new(uri.request_uri)
        req.basic_auth id,key
        begin
        response = Net::HTTP.start(uri.hostname,uri.port) { |http|
            http.request(req)
        }
        rescue Exception => exc
            puts exc.message
            self.status_trackers.add("ERROR"+"Get from FTP" +exc.message + uri.path)
            return nil
        end
        case response
        when Net::HTTPOK
            r = response.body.encode(Encoding::UTF_8, Encoding::CP1251, {   :invalid => :replace,
                                                                            :undef   => :replace,
                                                                            :replace => '?'})
            h = CSV.parse( r, 
                        {:headers => true,  :col_sep => ';'})
            

            return h
         when Net::HTTPClientError, Net::HTTPInternalServerError
            puts (response.code + response.message)
            return nil
        end
    end    

    

    def get_csv_from_ftp (uri,file,id,key)
        ftp = Net::FTP.new
        puts uri
        begin
        ftp.connect(uri,21)
        ftp.login(id,key)
        ftp.passive = true
        filename = "tmp/upload.csv"+DateTime.now.to_i.to_s
        ftp.getbinaryfile(file,filename)
        rescue Exception => exc
                puts exc.message
                logger.error exc.message
                return nil
        end
        ftp.close
        csv= File.open(filename)
                r = csv.read.encode(Encoding::UTF_8, Encoding::CP1251, {   :invalid => :replace,
                                                                                :undef   => :replace,
                                                                                :replace => '?'})
                h = CSV.parse( r, 
                            {:headers => true,  :col_sep => ';'})
                
                logger.info h.size if h
                puts h.size
                File.delete(filename)
                return h
    
        
    end
    
    
end
