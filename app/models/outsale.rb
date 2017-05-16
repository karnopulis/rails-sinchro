class Outsale < Site
     def add_Collection_to_frontend(collection)
        message = ApplicationController.new.view_context.render( :partial => "outsales/add_collection.json.jbuilder", :locals => {:new_collection =>  collection})
        
        response = post_to_url_json(URI("http://"+self.url+"/api/"+"collections.json"),message , site_login, self.site_pass)
        # return response
    end
    def self.add_Collections_to_frontend(collections,url,site_login,site_pass)
        message = ApplicationController.new.view_context.render( :partial => "outsales/add_collections.json.jbuilder", :locals => {:new_collections =>  collections})
        
        # response = post_to_url_json(URI("http://"+url+"/api/"+"collections_group_create.json"),message , site_login, site_pass)
        # return response
    end
    def self.add_Products_to_frontend(products,url,site_login,site_pass)
        message = ApplicationController.new.view_context.render( :partial => "outsales/add_product.json.jbuilder", :locals => {:new_offers =>  products})
        
#        response = post_to_url_json(URI("http://"+self.url+"/api/"+"products_group_create.json"),message , self.site_login, self.site_pass)
#        return response
    end
    def add_Product_to_frontend(product)
        message = ApplicationController.new.view_context.render( :partial => "outsales/add_product.json.jbuilder", :locals => {:new_product =>  product})
        puts message
        response = post_to_url_json(URI("http://"+self.url+"/api/"+"products.json"),message , self.site_login, self.site_pass)
#        return response
    end
    def add_Collect_to_frontend(collect)
        message = ApplicationController.new.view_context.render( :partial => "outsales/add_collect.json.jbuilder", :locals => {:new_collect => collect})
        
        response = post_to_url_json(URI("http://"+self.url+"/api/"+"collects.json"),message , self.site_login, self.site_pass)
        #return response
    end
     def add_Collects_to_frontend(collects,url,site_login,site_pass)
        message = ApplicationController.new.view_context.render( :partial => "outsales/add_collect.json.jbuilder", :locals => {:new_collects => collects})
        
        #response = post_to_url_json(URI("http://"+self.url+"/api/"+"collects_group_create.json"),message , self.site_login, self.site_pass)
        #return response
    end
    def add_Picture_to_frontend(image)
        message = ApplicationController.new.view_context.render( :partial => "outsales/add_image.json.jbuilder", :locals => {:new_image =>  image})
        
        response = post_to_url_json(URI("http://"+self.url+"/api"+"/images.json"),message , self.site_login, self.site_pass)
        return response
    end
    def self.edit_Products_to_frontend(products,url,site_login,site_pass)
        message = ApplicationController.new.view_context.render( :partial => "outsales/edit_product.json.jbuilder", :locals => {:edit_offers =>  products})

        response = put_to_url_json(URI("http://"+self.url+"/api/"+"products/"+product.original_id.to_s+".json"),message , self.site_login, self.site_pass)
#        return response
    end
    def edit_Product_to_frontend(product)
        message = ApplicationController.new.view_context.render( :partial => "outsales/edit_product.json.jbuilder", :locals => {:edit_product =>  product})

        response = put_to_url_json(URI("http://"+self.url+"/api/"+"products/"+product.original_id.to_s+".json"),message , self.site_login, self.site_pass)
#        return response
    end
    def edit_Collection_to_frontend(collection)
        message = ApplicationController.new.view_context.render( :partial => "outsales/edit_collection.json.jbuilder", :locals => {:edit_collection =>  collection})

        response = put_to_url_json(URI("http://"+self.url+"/api/"+"collections/"+collection.original_id.to_s+".json"),message , self.site_login, self.site_pass)
        return response
    end
    def edit_Variants_to_frontend(variants)
        message = ApplicationController.new.view_context.render( :partial => "outsales/edit_variants.json.jbuilder", :locals => {:edit_variants =>  variants})

        response = put_to_url_json(URI("http://"+self.url+"/api/"+"variants/"+"update_bulk.json"),message , self.site_login, self.site_pass)
        # return response
    end
    def edit_Variant_to_frontend(variant)
        message = ApplicationController.new.view_context.render( :partial => "outsales/edit_variant.json.jbuilder", :locals => {:edit_variant =>  variant})

        response = put_to_url_json(URI("http://"+self.url+"/api/"+"variants/"+variant.original_id.to_s+".json"),message , self.site_login, self.site_pass)
        # return response
    end
     def delete_Product_from_frontend(product)
    
        response = delete_url_json( URI("http://"+self.url+"/api/"+"products/"+product.original_id.to_s+".json"), self.site_login, self.site_pass)
        return response
    end
     def delete_Picture_from_frontend(image)
    
        response = delete_url_json( URI("http://"+self.url+"/api/"+"images/"+image.original_id.to_s+".json"), self.site_login, self.site_pass)
        return response
    end
    def delete_Collection_from_frontend(collection)
    
        response = delete_url_json( URI("http://"+self.url+"/api/"+"collections/"+collection.collection_original_id.to_s+".json"), self.site_login, self.site_pass)
        return response
    end
        def delete_Collect_from_frontend(collect)
    
        response = delete_url_json( URI("http://"+self.url+"/api/"+"collects/"+collect.collect_original_id.to_s+".json"), self.site_login, self.site_pass)
        return response
    end
    def get_Collections_from_frontend
        response = get_from_url( URI("http://"+self.url+"/api/"+"collections.json"), self.site_login, self.site_pass)
        # puts response
        response["collections"]
    end
    def get_Properties_from_frontend
        response = get_from_url( URI("http://"+self.url+"/api/"+"properties.json"), self.site_login, self.site_pass)
        response["properties"]
    end
    def get_Categories_from_frontend
        puts "http://"+self.url+"/api/"+"categories.json"
        response = get_from_url( URI("http://"+self.url+"/admin/"+"categories.json"), self.site_login, self.site_pass)

        response["categories"]
    end

    def get_Offers_from_frontend_products(compare)
        response = get_from_frontend_page( "http://"+self.url+"/api/"+"products.json?per_page=500&", "products", compare )
        #File.open("products.xml", "w") { |file| file.write response.to_xml}
         #response= Hash.from_xml(File.open("products.xml"))
         #response=h["products"]
         return response
    end
    def get_Collects_from_frontend(compare)
        response = get_from_frontend_page( "http://"+self.url+"/api/"+"collects.json?per_page=2000&", "collects",compare)
    end
    
    def get_import_from_odin_ass
        response=nil
        if self.soap_url.to_s.size > 0
            self.compares.last.status_trackers.add("INFO","Get from SOAP " + self.soap_url)
            response = get_csv_from_soap
        end
        if response.nil?
            self.compares.last.status_trackers.add("INFO","Get from FTP " + self.home_ftp)
            response = get_csv_from_ftp( self.home_ftp, self.home_file_name,  self.home_login, self.home_pass) if response.nil?
#        response = get_csv_from_url( URI("http://"+'94.141.184.178:5080'+"/ftp/site.csv"), home_login, home_pass)
        end
        return response
    end
        
    def get_from_frontend_page(uri,model,compare)
        i=1
#        h=[]
        loop do
            uri_page = ( URI (uri + "page="+i.to_s ) )
#            get_Collections_from_frontend
            
            r = get_from_url(uri_page, self.site_login, self.site_pass)

            puts uri_page.to_s
            break if r[model].size ==0
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
             self.compares.last.status_trackers.add("ERROR","Get from outsales" +exc.message + uri.path)
            return nil
        end

        case resp
        when Net::HTTPOK
            h=JSON.parse(resp.body)
            puts resp
            if h["nil_classes"]
                return nil
            else
                return h
            end
        else 
            puts (resp.code + resp.message)
            self.compares.last.status_trackers.add("ERROR","Get from outsales" +resp.code + resp.message+uri.path)
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
            self.compares.last.status_trackers.add("ERROR","Get from FTP" +exc.message + uri.path)
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
    
        def get_csv_from_soap
        client = Savon.client(wsdl: 'http://'+self.soap_url,basic_auth: [self.soap_login, self.soap_pass], read_timeout: 6000, convert_request_keys_to: :camelcase)
        begin 
            r= client.call(:get_data, message: {FileName: home_file_name})
            h = CSV.parse( r.body[:get_data_response][:return], {:headers => true,  :col_sep => ';'})
            throw r.body[:get_data_response][:return] if h.size== 0  
            return h
        rescue Exception => exc
                puts exc.message
                self.compares.last.status_trackers.add("ERROR","Get from SOAP " +exc.message )
                return nil
        end
    end
end

    

