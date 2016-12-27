class CreatePictureImports < ActiveRecord::Migration
  def change
    create_table :picture_imports do |t|
      t.string :url
      t.references :offer_import, index:true

      t.timestamps null: false
    end
  end
end
