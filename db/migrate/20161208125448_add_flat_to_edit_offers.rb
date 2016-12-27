class AddFlatToEditOffers < ActiveRecord::Migration
  def change
    add_column :edit_offers, :flat, :string
  end
end
