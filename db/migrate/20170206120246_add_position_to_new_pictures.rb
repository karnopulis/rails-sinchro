class AddPositionToNewPictures < ActiveRecord::Migration[5.0]
  def change
    add_column :new_pictures, :position, :integer
  end
end
