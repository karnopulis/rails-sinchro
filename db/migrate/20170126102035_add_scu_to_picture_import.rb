class AddScuToPictureImport < ActiveRecord::Migration[5.0]
  def change
    add_column :picture_imports, :scu, :string
  end
end
