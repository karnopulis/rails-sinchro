class AddSizeToPicture < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :size, :integer
  end
end
