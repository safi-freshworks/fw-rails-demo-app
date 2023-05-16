class AddPinColToUser < ActiveRecord::Migration
  def change
    add_column :users, :pin, :int
  end
end
