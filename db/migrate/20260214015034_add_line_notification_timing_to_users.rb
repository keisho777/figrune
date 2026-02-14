class AddLineNotificationTimingToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :line_notification_timing, :integer, default: 4, null: false
  end
end
