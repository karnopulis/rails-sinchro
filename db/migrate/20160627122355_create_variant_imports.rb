class CreateVariantImports < ActiveRecord::Migration
  def change
    create_table :variant_imports do |t|
      t.integer :quantity
      t.string :scu
      t.string :pric_flat
      t.references :compare , index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
