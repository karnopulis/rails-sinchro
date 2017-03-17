class CreateHandlerErrors < ActiveRecord::Migration[5.0]
  def change
    create_table :handler_errors do |t|
      t.references :compare, foreign_key: true
      t.string :model
      t.integer :model_id
      t.string :message
      t.integer :tryes_left

      t.timestamps
    end
  end
end
