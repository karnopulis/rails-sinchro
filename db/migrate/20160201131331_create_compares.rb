class CreateCompares < ActiveRecord::Migration
  def change
    create_table :compares do |t|
      t.string :name


      t.timestamps null: false
    end
  end
end
