class AddFilenameToPictureImport < ActiveRecord::Migration[5.0]
  def change
    add_column :picture_imports, :filename, :string
  end
end
