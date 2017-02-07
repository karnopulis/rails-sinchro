class AddPositiontoPictureImports < ActiveRecord::Migration[5.0]
  def change
    add_column :picture_imports, :position, :integer
  end
end
