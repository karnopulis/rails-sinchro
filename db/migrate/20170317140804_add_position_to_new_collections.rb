class AddPositionToNewCollections < ActiveRecord::Migration[5.0]
  def change
    add_column :new_collections, :position, :integer
  end
end
