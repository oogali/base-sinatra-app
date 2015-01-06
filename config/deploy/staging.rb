set :rails_env, 'staging'
set :env, 'staging'

role :app, 'localhost'
role :db, 'localhost', :primary => true
