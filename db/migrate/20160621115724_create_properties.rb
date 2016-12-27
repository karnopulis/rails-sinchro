class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer :original_id
      t.string :title

      t.timestamps null: false
    end
  end
end
