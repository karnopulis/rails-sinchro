class CreateCollectImports < ActiveRecord::Migration
  def change
    create_table :collect_imports do |t|
      t.string :scu
      t.string :flat
      t.references :compare, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
