class AddFlatToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :flat, :string
  end
end
