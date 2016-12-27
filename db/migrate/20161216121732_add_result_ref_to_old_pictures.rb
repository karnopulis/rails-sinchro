class AddResultRefToOldPictures < ActiveRecord::Migration
  def change
        add_reference :old_pictures, :result, index: true, foreign_key: true
  end
end
