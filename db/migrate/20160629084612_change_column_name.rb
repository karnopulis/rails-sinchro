class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :prices, :type, :title
  end
end
