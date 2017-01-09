require 'net/ftp'

class Site < ActiveRecord::Base
    has_many :compares, dependent: :destroy
    
    def get_Collections_from_insales
        response = get_from_url( URI("http://"+self.url+"/admin/"+"collections.xml"), self.site_login, self.site_pass)
        response["collections"]
    end
    def get_Properties_from_insales
        response = get_from_url( URI("http://"+self.url+"/admin/"+"properties.xml"), self.site_login, self.site_pass)
        response["properties"]
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

 
 
    def get_from_url (uri, id,key )
        req  = Net::HTTP::Get.new(uri.request_uri)
        req.basic_auth id,key
        puts "+++++++++++++++++++"
        begin
        resp = Net::HTTP.start(uri.hostname,uri.port) { |http|
            http.request(req)
            
        }
        rescue Exception => exc
            puts exc.message
            return nil
        end
        r = resp.get_fields("api-usage-limit")
        if r
            r= r[0].split('/')
            puts resp.get_fields("api-usage-limit").to_s
            puts r[0].to_i
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
        begin
        ftp.connect(uri,21)
        ftp.login(id,key)
        ftp.passive = true
        ftp.getbinaryfile(file,"upload.csv")
        rescue Exception => exc
                puts exc.message
                return nil
        end
        ftp.close
        csv= File.open("upload.csv")
                r = csv.read.encode(Encoding::UTF_8, Encoding::CP1251, {   :invalid => :replace,
                                                                                :undef   => :replace,
                                                                                :replace => '?'})
                h = CSV.parse( r, 
                            {:headers => true,  :col_sep => ';'})
                
    
                return h
    
        
    end
    
    
end
