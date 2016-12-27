class AddCompareRefToOffers < ActiveRecord::Migration
  def change
    add_reference :offers, :compare, index: true 
  end
end
