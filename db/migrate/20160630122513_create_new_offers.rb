class CreateNewOffers < ActiveRecord::Migration
  def change
    create_table :new_offers do |t|
      t.string :state
      t.text :error
      t.references :result, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
