class AddScuToPicture < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :scu, :string
  end
end
