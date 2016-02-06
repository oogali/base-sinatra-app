# This is where you would define your database seed data
# It's not complicated -- nothing more than ActiveRecord statements

# create new user account for test login, with a default password
user = AppName::Db::User.create :username => 'test', :passwd => BCrypt::Password.create('changeme!', :cost => 6)
