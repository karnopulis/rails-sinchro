class ChangeCollectionsParentType < ActiveRecord::Migration[5.0]
  def change
        change_column :collections, :parent, :integer

  end
end
