class CreateUsersTable < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, { unique: true, null: false }
      t.string :passwd, null: false
      t.string :name
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :users
  end
end
