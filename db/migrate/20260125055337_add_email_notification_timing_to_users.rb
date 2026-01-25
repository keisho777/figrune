class AddEmailNotificationTimingToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :EmailNotificationTiming, :integer, default: 4, null: false
  end
end
