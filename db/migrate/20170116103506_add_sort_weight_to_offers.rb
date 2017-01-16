class AddSortWeightToOffers < ActiveRecord::Migration[5.0]
  def change
    add_column :offers, :sort_weight, :string
  end
end
