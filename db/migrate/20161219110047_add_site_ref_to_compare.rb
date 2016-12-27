class AddSiteRefToCompare < ActiveRecord::Migration
  def change
    add_reference :compares, :site, index: true, foreign_key: true
  end
end
