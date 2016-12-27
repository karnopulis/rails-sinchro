class CreateOldCollects < ActiveRecord::Migration
  def change
    create_table :old_collects do |t|
      t.integer :collect_original_id
      t.string  :state
      t.text :error
      t.string :collection_flat
      t.string :product_scu
      t.references :result, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
