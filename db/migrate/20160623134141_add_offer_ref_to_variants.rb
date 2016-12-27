class AddOfferRefToVariants < ActiveRecord::Migration
  def change
    add_reference :variants, :offer, index: true, foreign_key: true
  end
end
