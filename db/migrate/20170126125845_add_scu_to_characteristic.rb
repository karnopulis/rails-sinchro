class AddScuToCharacteristic < ActiveRecord::Migration[5.0]
  def change
    add_column :characteristics, :scu, :string
  end
end
