class AddToCompare < ActiveRecord::Migration[5.0]
  def change
    add_column :compares, :category_original_id, :integer
    add_column :compares, :global_parent_id, :integer
  end
end
