class AddImageStatusToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :image_status, :string
  end
end
