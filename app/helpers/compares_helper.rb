require "net/http"
require "csv"

module ComparesHelper

    def insales_key 
        "fa0e77096f1a2c38b080aed9e4899dd1" #gk
#         "4e79bc2f694edc11643572e0c9002e2b" #rostov
    end
    
    def insales_id
       "afcd84ca7c5e6f7cabeb11132dec61f1" #gk
#        "64ce9e69bffd8254f01898e10c28b804" #rostov
    end
    
    def domen
        "horosho-gk.ru"
#         "horosho-rostov.ru"    
    end
    def home_login
       "site" 
    end
    def home_pass
        "Hed88V"
    end
    
    def site_global_parent
#       "Товары" #rostov
        "Каталог" #gk
    end
    
    def csv_collection_order
        ["Родитель1","Родитель5","Родитель4","Родитель3","Родитель2"] #gk
#       ["Родитель5","Родитель4","Родитель3","Родитель2","Родитель1"] #rostov
    end
    def csv_variant_order
        ["01.Базовая цена","01.Базовая цена","01.Базовая ценаПЛЮС100","11.Розн.3","10.МДК"] #gk
#        ["Артикул","Количество","Розничная цена","Оптовая цена"]       #rostov
    end
    def site_variant_order
        ["price","price2","price3","price4","price5"] #gk
#        ["sku","quantity","price2","price"] #rostov
    end
    
    def csv_offer_order
        ["Текст внутри","Отделка","Формат открытки","Кол-во в упак.",
         "Родитель1","Код цены","Актуальность","Конструктив",
         "Послеобрезной формат","АктуальностьЦифра","Дата первого прихода",
         "Материал изг."] #gk
    end
    
    def site_offer_order
        ["текст","Отделка","Формат","Количество в упаковке",
        "поставщик","Код цены","Поступления","конструктив",
        "Размер","ац","Дата первого прихода",
        "Материал"]#gk
    end
    
    def sort_order
        "АктуальностьЦифра"
    end
    
    def scu_field
         "Артикул"
    end
    def quantity_field
         "Количество"
    end
    def title_field
        "Наименование"
    end
    def csv_images_order
        ["Изображение","ИзображениеОборота"]
    end
    
    
    def get_Collections_from_insales
        response = get_from_url( URI("http://"+domen+"/admin/"+"collections.xml"), insales_id, insales_key)
        response["collections"]
    end
    def get_Properties_from_insales
        response = get_from_url( URI("http://"+domen+"/admin/"+"properties.xml"), insales_id, insales_key)
        response["properties"]
    end
    def get_Offers_from_insales_marketplace
        response = get_from_url( URI("http://"+domen+"/marketplace/24025.xml"), insales_id, insales_key) #gk
#        response = get_from_url( URI("http://"+domen+"/marketplace/26603.xml"), insales_id, insales_key) #rostov
        response["yml_catalog"]["shop"]["offers"]["offer"]
    end
    def get_Offers_from_insales_products
        response = get_from_insales_page( "http://"+domen+"/admin/"+"products.xml?per_page=250&", "products" )
        #File.open("products.xml", "w") { |file| file.write response.to_xml}
         #response= Hash.from_xml(File.open("products.xml"))
         #response=h["products"]
         return response
    end
    def get_Collects_from_insales
        response = get_from_insales_page( "http://"+domen+"/admin/"+"collects.xml?", "collects")
    end
    
    def get_import_from_odin_ass
        response = get_csv_from_url( URI("http://"+'94.141.184.178:5080'+"/ftp/horosho.csv"), home_login, home_pass)
#        response = get_csv_from_url( URI("http://"+'94.141.184.178:5080'+"/ftp/site.csv"), home_login, home_pass)
    end
        
    def get_from_insales_page(uri,model)
        i=1
        h=[]
        loop do
            uri_page = ( URI (uri + "page="+i.to_s ) )
            get_Collections_from_insales
            
            r = get_from_url(uri_page, insales_id ,insales_key)

            puts uri_page.to_s
            break if r == nil
            File.open("products"+i.to_s+".xml", "w") { |file| file.write r.to_xml}

            h=h + r[model]
            i+=1
            puts h.class
        end
        return h
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

    
end



