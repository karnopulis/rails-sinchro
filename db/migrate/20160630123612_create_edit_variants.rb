class CreateEditVariants < ActiveRecord::Migration
  def change
    create_table :edit_variants do |t|
      t.string :scu
      t.integer :quantity
      t.integer :original_id
      t.string :state
      t.text :error
      t.references :result, index: true
      t.references :new_offer, index: true
      t.timestamps null: false
    end
  end
end
