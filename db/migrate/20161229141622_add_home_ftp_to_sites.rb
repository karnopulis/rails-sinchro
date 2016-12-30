class AddHomeFtpToSites < ActiveRecord::Migration
  def change
    add_column :sites, :home_ftp, :string
  end
end
