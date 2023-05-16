class AddUserPerferencesToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_preferences, :text
  end
end
