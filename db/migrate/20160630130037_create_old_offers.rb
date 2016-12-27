class CreateOldOffers < ActiveRecord::Migration
  def change
    create_table :old_offers do |t|
      t.string :scu
      t.integer :original_id
      t.string :state
      t.text :error
      t.references :result, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
