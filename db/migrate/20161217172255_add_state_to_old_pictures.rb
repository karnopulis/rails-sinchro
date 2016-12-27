class AddStateToOldPictures < ActiveRecord::Migration
  def change
    add_column :old_pictures, :state, :string
    add_column :old_pictures, :error, :string
  end
end
