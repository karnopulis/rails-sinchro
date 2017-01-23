include ComparesHelper
class CollectImport < ApplicationRecord
  belongs_to :compare
  


#  TOP="parent"
  TOP=nil

  def self.create_collects(collections,compare)
    result=[]
    collections.each do |cc|
      
      rez =CollectImport.create_chain( cc )
    
      result =result+rez if rez.size>0
    end
    
    result= result.uniq;
    
    
    ci_arr=[]
    result.each do |r|
      ci_arr << CollectImport.create_new(r[0],r[1],compare)
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
 
  def self.create_new(scu,arr,compare) 
    ci = self.new
    ci.scu =scu
    ci.flat=arr
    ci.compare=compare
    return ci
  end
  
  
  
end
