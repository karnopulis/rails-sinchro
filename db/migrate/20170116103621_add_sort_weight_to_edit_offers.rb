class AddSortWeightToEditOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :edit_offers, :sort_weight, :string
  end
end
