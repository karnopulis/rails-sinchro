class AddOriginalIdToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :original_id, :integer
  end
end
