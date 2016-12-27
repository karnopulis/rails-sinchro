class CreateOldCollections < ActiveRecord::Migration
  def change
    create_table :old_collections do |t|
      t.integer :collection_original_id
      t.string :state
      t.text :error
      t.string :collection_flat
      t.references :old_collection, index: true, foreign_key: true
      t.references :result, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
