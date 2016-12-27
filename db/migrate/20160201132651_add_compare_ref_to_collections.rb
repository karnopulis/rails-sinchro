class AddCompareRefToCollections < ActiveRecord::Migration
  def change
    add_reference :collections, :compare, index: true 
  end
end
