class AddCompareRefToProperties < ActiveRecord::Migration
  def change
    add_reference :properties, :compare, index: true, foreign_key: true
  end
end
