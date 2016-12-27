class CreateEditOffers < ActiveRecord::Migration
  def change
    create_table :edit_offers do |t|
      t.string :scu
      t.string :title
      t.integer :original_id
      t.string :state
      t.text :error
      t.references :result, index: true
      t.references :new_offer, index: true
      t.timestamps null: false
    end
  end
end
