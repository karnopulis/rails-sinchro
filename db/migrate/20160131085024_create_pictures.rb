class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :url
      t.references :offer, index:true

      t.timestamps null: false
    end
  end
end
