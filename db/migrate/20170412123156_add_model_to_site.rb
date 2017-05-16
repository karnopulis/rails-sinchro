class AddModelToSite < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :model, :string
  end
end
