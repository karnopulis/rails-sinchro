class Collection < ApplicationRecord
    belongs_to :compare
    has_many :collects, dependent: :delete_all
    has_many :offers, :through => :collects
  

    def new_from_hash (h,site_global_parent,compare_id)
        oo=[]
#        top_level = h.select{|a| a["parent_id"].to_i==0 }
        top_level = h.select{|a| a["title"] == site_global_parent }
#        puts top_level
        top_level = top_level[0]["id"].to_i if top_level
        c= Compare.find(compare_id)
        c.global_parent_id=top_level
        c.save
        h.each { |a| 
            o = Collection.new()
            o.original_id = a["id"].to_i
            o.name = a["title"]
            o.parent= a["parent_id"].to_i
            o.compare_id =compare_id
            if (o.parent!=0)
                # if o.name == site_global_parent
                #     o.flat= generate_flat( o.name, o.parent, o.parent, h )
                # else
                    o.flat= generate_flat( o.name, o.parent, top_level, h )
                # end
                oo << o if o.flat
#                puts o.flat
        end
        }
       return oo
    end
    
    def generate_flat( name, id , top_level, h)
        tflat=""
        top_level_include =0
        while  id!=0  do
#            puts id
            p= h.select{|a| a["id"]==id}
            if id == top_level
                top_level_include= 1 
                break
            else
                cur_level =p[0]["title"].to_s
                tflat=cur_level+";"+tflat 
                id =p[0]["parent_id"].to_i
            end
        end
        tflat+=name+";"
        tflat=nil if top_level_include==0
        return tflat
    end
end
