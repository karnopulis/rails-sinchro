class AddScuToPrice < ActiveRecord::Migration[5.0]
  def change
    add_column :prices, :sku, :string
  end
end
