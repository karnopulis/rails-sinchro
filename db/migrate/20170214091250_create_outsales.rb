class CreateOutsales < ActiveRecord::Migration[5.0]
  def change
    create_table :outsales do |t|

      t.timestamps
    end
  end
end
