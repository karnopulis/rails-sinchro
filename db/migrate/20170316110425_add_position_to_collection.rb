class AddPositionToCollection < ActiveRecord::Migration[5.0]
  def change
    add_column :collections, :position, :integer
  end
end
