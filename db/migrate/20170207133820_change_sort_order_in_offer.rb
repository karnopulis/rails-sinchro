class ChangeSortOrderInOffer < ActiveRecord::Migration[5.0]
  def change
    change_column :offers, :sort_weight, :float
  end
end
