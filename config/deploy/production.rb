set :rails_env, 'production'
set :env, 'production'

role :app, 'localhost'
role :db, 'localhost', :primary => true
