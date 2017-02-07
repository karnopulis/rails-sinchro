class ChangeColumnInOfferImport < ActiveRecord::Migration[5.0]
  def change
    change_column :offer_imports, :sort_order, :float
  end
end
