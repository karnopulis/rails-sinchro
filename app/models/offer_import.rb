class OfferImport < ApplicationRecord
        belongs_to :compare
        has_many :picture_imports, dependent: :delete_all
    
    def self.create_new(row,compare) 
        pi=[]
        oi = self.new
#        vi.scu =row[scu_field]
         oi.scu = row[0]
#        vi.title =row[title_field]
         oi.title =row[1]
#        vi.sort_order = row[sort_order]
            
         oi.sort_order =row[2].to_f
#       arr =row.to_hash.values_at(*csv_offer_order)#.compact

         oi.image_status=""
         oi.image_status = row[3].split("/").last+";" if not row[3]==nil
        #  kostil=nil
        #  row[5]=nil if row[3]==nil
        #  if  row[5]!=nil && row[5]="есть"
        #      yura_suka = row[3].split(".")
        #      yura_suka[yura_suka.size-1] = "back."+yura_suka.last
        #      kostil=yura_suka.join(".")
        #  end
         oi.image_status += row[5].split("/").last+";" if not row[5]==nil
#         puts oi.image_status
         pi << PictureImport.create_new(row[3],oi,row[0],1,row[4])  if not row[3]==nil
         pi << PictureImport.create_new(row[5],oi,row[0],2,row[6])  if not row[5]==nil     
         arr = row[7..100]
        oi.prop_flat=arr.join(';')
        oi.compare=compare
    return oi, pi
  end
    
end
