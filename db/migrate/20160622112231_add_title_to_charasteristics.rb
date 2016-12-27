class AddTitleToCharasteristics < ActiveRecord::Migration
  def change
    add_column :characteristics, :title, :string
  end
end
