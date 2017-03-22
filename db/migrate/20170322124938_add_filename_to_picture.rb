class AddFilenameToPicture < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :filename, :string
  end
end
