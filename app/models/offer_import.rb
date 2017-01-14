class OfferImport < ApplicationRecord
        belongs_to :compare
        has_many :picture_imports
    
    def self.create_new(row,compare) 
        oi = self.new
#        vi.scu =row[scu_field]
         oi.scu = row[0]
#        vi.title =row[title_field]
         oi.title =row[1]
#        vi.sort_order = row[sort_order]
         oi.sort_order =row[2]
#       arr =row.to_hash.values_at(*csv_offer_order)#.compact

         oi.image_status=""
         oi.image_status = row[3].split("/").last+";" if not row[3]==nil
         oi.image_status += row[4].split("/").last+";" if not row[4]==nil
#         puts oi.image_status
         oi.picture_imports << PictureImport.create_new(row[3])  if not row[3]==nil
         oi.picture_imports << PictureImport.create_new(row[4])  if not row[4]==nil       
         arr = row[5..100]
        oi.prop_flat=arr.join(';')
        oi.compare=compare
    return oi
  end
    
end
