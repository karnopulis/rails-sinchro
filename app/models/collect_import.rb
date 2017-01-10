include ComparesHelper
class CollectImport < ActiveRecord::Base
  belongs_to :compare
  


#  TOP="ЗАО 'ГК Горчаков'"
  TOP=nil

  def self.create_collects(collections)
    result=[]
    collections.each do |cc|
      
      rez =CollectImport.create_chain( cc )
    
      result =result+rez if rez.size>0
    end
    
    result= result.uniq;
    
    
    ci_arr=[]
    result.each do |r|
      ci_arr << CollectImport.create_new(r[0],r[1])
    end
    return ci_arr
    #return result
  end
  
  def self.create_chain(row)
    rez=[]
#    colls =row.to_hash.extract!(*csv_collection_order).compact.values
     colls =row[1..100].compact
    begin
        if colls
            rez << [row[0],colls.join(";")] 
            colls.pop
        else 
            return rez
        end
    end while colls.last != TOP
    return rez
  end
 
  def self.create_new(scu,arr) 
    ci = self.new
    ci.scu =scu
    ci.flat=arr
    return ci
  end
  
  
  
end
