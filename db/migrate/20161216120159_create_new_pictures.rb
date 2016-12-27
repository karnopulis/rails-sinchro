class CreateNewPictures < ActiveRecord::Migration
  def change
    create_table :new_pictures do |t|
      t.string :url
      t.string :scu
      t.string :original_offer_id

      t.timestamps null: false
    end
  end
end
