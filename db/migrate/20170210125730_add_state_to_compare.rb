class AddStateToCompare < ActiveRecord::Migration[5.0]
  def change
    add_column :compares, :state, :string
  end
end
