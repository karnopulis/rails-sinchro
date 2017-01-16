class CreateInsales < ActiveRecord::Migration[5.0]
  def change
    create_table :insales do |t|

      t.timestamps
    end
  end
end
