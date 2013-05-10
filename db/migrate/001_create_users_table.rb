class CreateUsersTable < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.primary_key :id
      t.string :username, { :unique => true, :null => false }
      t.string :passwd, :null => false
      t.string :name
      t.timestamps
    end

    # create new user account for test login, with a default password
    user = AppName::Db::User.create :username => 'test', :passwd => BCrypt::Password.create('changeme!', :cost => 6)
  end

  def self.down
    drop_table :users
  end
end
