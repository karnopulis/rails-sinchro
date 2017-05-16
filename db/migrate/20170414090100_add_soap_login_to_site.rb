class AddSoapLoginToSite < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :soap_login, :string
    add_column :sites, :soap_pass, :string
    add_column :sites, :soap_url, :string
  end
end
