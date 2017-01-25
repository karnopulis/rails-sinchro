class AddNewImagesRefToNewOffer < ActiveRecord::Migration
  def change
    add_reference :new_pictures, :new_offer, index: true
  end
end
