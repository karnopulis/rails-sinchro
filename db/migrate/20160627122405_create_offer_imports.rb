class CreateOfferImports < ActiveRecord::Migration
  def change
    create_table :offer_imports do |t|
      t.string :title
      t.string :prop_flat
      t.integer :sort_order
      t.string :scu
      t.references :compare , index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
