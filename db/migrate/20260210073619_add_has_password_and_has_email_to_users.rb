class AddHasPasswordAndHasEmailToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :has_password, :boolean, default: true, null: false
    add_column :users, :has_email, :boolean, default: true, null: false
  end
end
