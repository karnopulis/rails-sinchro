class AddNewImagesRefToNewOffer < ActiveRecord::Migration
  def change
    add_reference :new_pictures, :new_offer, index: true, foreign_key: true
  end
end
