class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :url
      t.string :site_login
      t.string :site_pass
      t.string :home_login
      t.string :home_pass
      t.string :site_global_parent
      t.string :csv_collection_order
      t.string :csv_variant_order
      t.string :site_variant_order
      t.string :csv_offer_order
      t.string :site_offer_order
      t.string :sort_order
      t.string :scu_field
      t.string :quantity_field
      t.string :title_field
      t.string :csv_images_order
      t.timestamps null: false
    end
  end
end
