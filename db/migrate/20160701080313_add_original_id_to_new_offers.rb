class AddOriginalIdToNewOffers < ActiveRecord::Migration
  def change
    add_column :new_offers, :original_id, :integer
  end
end
