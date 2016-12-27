class CreateCollects < ActiveRecord::Migration
  def change
    create_table :collects do |t|
      t.integer :original_id
      t.references :collection, index:true
                    
       t.references :offer, index:true
       t.references :compare, index:true

      t.timestamps null: false
    end
  end
end
