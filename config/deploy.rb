set :application, 'appname'

set :repository,  '../'
set :scm, :git
set :branch, fetch(:branch, :master)
set :git_enable_submodules, 1

set :user, "#{application}"
set :use_sudo, false

set :copy_strategy, :export
# deploy_via:
# * :copy means SCP our files to the remote host from the local host
# * :remote_cache means check it out from the repository (e.g. Github, Bitbucket)
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{application}"
set :keep_releases, 5
set :normalize_asset_timestamps, false

## hipchat deploy announcements
# set :hipchat_token, 'HIPCHAT_API_TOKEN'
# set :hipchat_room_name, 'HIPCHAT_ROOM_NAME'
# set :hipchat_announce, true

role :app, 'localhost'
role :db, 'localhost', :primary => true

require 'bundler/capistrano'
require 'hipchat/capistrano'

namespace :deploy do
  task :start do
    run "cd #{deploy_to}/current && RACK_ENV=production #{rake} start"
  end

  task :stop do
    run "test -d #{deploy_to}/current && cd #{deploy_to}/current && RACK_ENV=production #{rake} stop"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.stop
    deploy.start
  end
end

namespace :config do
  task :setup_environment do
    run "ln -s #{shared_path}/log #{deploy_to}/current/run"
  end
end

after 'deploy:create_symlink', :roles => [ :db ] do
  deploy.migrate
end

after 'deploy:create_symlink', :roles => [ :app ] do
  config.setup_environment
end
