class CreateEditCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :edit_collections do |t|
      t.string :flat
      t.references :result, foreign_key: true
      t.integer :position
      t.integer :original_id
      t.string :state
      t.string :error

      t.timestamps
    end
  end
end
