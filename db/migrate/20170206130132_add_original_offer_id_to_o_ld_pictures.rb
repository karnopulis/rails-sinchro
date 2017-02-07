class AddOriginalOfferIdToOLdPictures < ActiveRecord::Migration[5.0]
  def change
    add_column :old_pictures, :original_offer_id, :integer
  end
end
