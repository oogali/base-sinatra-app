set :application, 'appname'

set :repository,  '../'
set :scm, :git
set :branch, :master
set :git_enable_submodules, 1

set :user, 'deploy'
set :use_sudo, false

set :copy_strategy, :export
set :deploy_via, :copy
set :deploy_to, "/home/#{user}/#{application}"
set :keep_releases, 5
set :normalize_asset_timestamps, false

## hipchat deploy announcements
# require 'hipchat/capistrano'
# set :hipchat_token, 'HIPCHAT_API_TOKEN'
# set :hipchat_room_name, 'HIPCHAT_ROOM_NAME'
# set :hipchat_announce, true

role :app, 'localhost'
role :db, 'localhost', :primary => true

require 'bundler/capistrano'

namespace :deploy do
  task :start do
    run "cd #{deploy_to}/current && #{rake} start"
  end

  task :stop do
    run "test -d #{deploy_to}/current && cd #{deploy_to}/current && #{rake} stop"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.stop
    deploy.start
  end
end

namespace :config do
  task :setup_log_path do
    run "ln -s #{shared_path}/log #{deploy_to}/current/run"
  end

  task :setup_environment do
    run "cd #{deploy_to}/current && ln -sf config_production.yml config.yml"
  end
end

before 'deploy:create_symlink', :roles => [ :app ] do
  deploy.stop
end

after 'deploy:create_symlink', :roles => [ :db ] do
  deploy.migrate
end

after 'deploy:create_symlink', :roles => [ :app ] do
  config.setup_log_path
  config.setup_environment
end
