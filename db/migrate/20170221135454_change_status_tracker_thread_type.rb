class ChangeStatusTrackerThreadType < ActiveRecord::Migration[5.0]
  def change
    change_column :status_trackers, :thread, :integer
  end
end
