class AddPositionToCollectImport < ActiveRecord::Migration[5.0]
  def change
    add_column :collect_imports, :position, :integer
  end
end
