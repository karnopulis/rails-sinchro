class AddPositionToOLdPicture < ActiveRecord::Migration[5.0]
  def change
    add_column :old_pictures, :position, :integer
  end
end
