class AddSizeToNewPicture < ActiveRecord::Migration[5.0]
  def change
    add_column :new_pictures, :size, :integer
  end
end
