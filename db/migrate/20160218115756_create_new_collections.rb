class CreateNewCollections < ActiveRecord::Migration
  def change
    create_table :new_collections do |t|
      t.integer :parent_id
      t.string :title
      t.string :collection_flat
      t.string :state
      t.text :error
      t.references :new_parent, index: true
      t.references :result, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
