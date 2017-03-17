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
      
      ci_arr << CollectImport.create_new(r,compare)
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
            rez.push( [row[0],*colls] ) 
#            puts [row[0],colls] 
            colls.pop
        else 
            return rez
        end
    end while colls.last != TOP
    return rez
  end
 
  def self.create_new(arr,compare) 
    ci = self.new
    ci.scu =arr[0]
#    puts scu
#    puts arr.join("f")
    ci.position=arr.last.split("|").try(:second).try(:to_i)
    ci.flat=arr[1...100].map{|v| v.split("|").first }.compact.join(";")+";"
    ci.compare=compare
    return ci
  end
  
  
  
end
