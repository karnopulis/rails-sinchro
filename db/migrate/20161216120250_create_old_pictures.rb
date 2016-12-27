class CreateOldPictures < ActiveRecord::Migration
  def change
    create_table :old_pictures do |t|
      t.string :scu
      t.string :original_id

      t.timestamps null: false
    end
  end
end
