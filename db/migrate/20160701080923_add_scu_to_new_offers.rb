class AddScuToNewOffers < ActiveRecord::Migration
  def change
    add_column :new_offers, :scu, :string
  end
end
