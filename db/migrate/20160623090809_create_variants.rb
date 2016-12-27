class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string :sku
      t.integer :quantity
      t.timestamps null: false
    end
  end
end
