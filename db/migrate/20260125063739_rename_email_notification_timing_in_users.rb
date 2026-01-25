class RenameEmailNotificationTimingInUsers < ActiveRecord::Migration[7.2]
  def change
    rename_column :users, :EmailNotificationTiming, :email_notification_timing
  end
end
