class AddOriginalIdToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :original_id, :integer
  end
end
