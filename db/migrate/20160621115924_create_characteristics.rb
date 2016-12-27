class CreateCharacteristics < ActiveRecord::Migration
  def change
    create_table :characteristics do |t|
      t.integer :original_id
      t.references :property, index: true
      t.references :offer, index: true

      t.timestamps null: false
    end
  end
end
