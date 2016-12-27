class AddFlatToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :flat, :string
  end
end
