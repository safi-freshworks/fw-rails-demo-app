class CreateUserInterests < ActiveRecord::Migration
  def change
    create_table :user_interests do |t|
      t.string :name
      t.references :user, index: true
      t.timestamps
    end
  end
end
