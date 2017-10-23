class AddSizeToPictureImport < ActiveRecord::Migration[5.0]
  def change
    add_column :picture_imports, :size, :integer
  end
end
