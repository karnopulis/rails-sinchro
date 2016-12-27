class AddStateToNewPictures < ActiveRecord::Migration
  def change
    add_column :new_pictures, :state, :string
    add_column :new_pictures, :error, :string
  end
end
