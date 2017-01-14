class VariantImport < ApplicationRecord
    belongs_to :compare
    
    def self.create_new(row,compare) 
    vi = self.new
#    vi.scu =row[scu_field]
    vi.scu =row[0]
#    vi.quantity =row[quantity_field]
    vi.quantity =row[1]
#    arr =row.to_hash.values_at(*csv_variant_order)
    arr = row[2..100]
    vi.pric_flat = arr.map {|m| m.gsub(',','.').to_f.to_s if m }.join(";")
    #h= csv_variant_order.zip(arr).to_h.to_s
    #vi.pric_flat=h
    vi.compare=compare
    return vi
  end
    
end
