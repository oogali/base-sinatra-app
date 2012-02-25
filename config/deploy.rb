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

role :app, 'localhost'
role :db, 'localhost', :primary => true

require 'bundler/capistrano'

namespace :deploy do
  task :start do
    run "cd #{deploy_to}/current && #{rake} start"
  end

  task :stop do
    run "cd #{deploy_to}/current && #{rake} stop"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{deploy_to}/current && #{rake} restart"
  end
end

after 'deploy:symlink', :roles => [ :app ] do
  run "ln -s #{shared_path}/log #{deploy_to}/current/run"
end
