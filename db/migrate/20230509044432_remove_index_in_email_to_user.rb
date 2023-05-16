class RemoveIndexInEmailToUser < ActiveRecord::Migration
  def up
    remove_index  :users, :email if index_exists?(:users, :email)
  end

  def down
    add_index  :users, :email unless index_exists?(:users, :email)
  end
end
