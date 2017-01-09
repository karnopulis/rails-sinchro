class AddHomeFileNameToSites < ActiveRecord::Migration
  def change
    add_column :sites, :home_file_name, :string
  end
end
