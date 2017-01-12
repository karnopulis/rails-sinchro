class AddNewImagesRefToNewOffer < ActiveRecord::Migration
  def change
    add_reference :new_offers, :new_picture, index: true, foreign_key: true
  end
end
