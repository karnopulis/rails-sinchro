class CreateStatusTrackers < ActiveRecord::Migration[5.0]
  def change
    create_table :status_trackers do |t|
      t.references :compare, foreign_key: true
      t.datetime :date
      t.string :level
      t.string :thread
      t.string :message

      t.timestamps
    end
  end
end
