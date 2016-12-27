class AddResultRefToNewPictures < ActiveRecord::Migration
  def change
    add_reference :new_pictures, :result, index: true, foreign_key: true
  end
end
