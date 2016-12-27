class AddImageStatusToOfferImport < ActiveRecord::Migration
  def change
    add_column :offer_imports, :image_status, :string
  end
end
