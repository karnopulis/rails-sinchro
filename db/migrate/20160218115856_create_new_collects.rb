class CreateNewCollects < ActiveRecord::Migration
  def change
    create_table :new_collects do |t|
      t.integer :collection_original_id
      t.integer :product_original_id
      t.string :collection_flat
      t.string :product_scu
      t.string :state
      t.text :error
      t.references :new_collection, index: true
      t.references :new_product , index: true, foreign_key: true
      t.references :result, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
