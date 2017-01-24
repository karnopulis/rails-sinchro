class AddStateToNewPictures < ActiveRecord::Migration
  def change
    add_column :new_pictures, :state, :string
    add_column :new_pictures, :error, :string
    add_reference :new_pictures, :new_offer, index: true, foreign_key: true

  end
end
