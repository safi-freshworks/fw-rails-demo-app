class ChangePinColumnTypeIntToBigInt < ActiveRecord::Migration
  def up
    change_column(:users, :pin, :bigint)
  end
  def down
    change_column(:users, :pin, :int)
  end
end
