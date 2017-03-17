class AddSiteCollectionsOrderToSite < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :site_collections_order, :string
    add_column :sites, :csv_collections_order, :string
  end
end
