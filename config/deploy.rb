set :application, 'appname'

set :repo_url,  '../'
set :scm, :git
set :branch, fetch(:branch, :master)
set :git_enable_submodules, 1

set :user, fetch(:application)
set :use_sudo, false
set :group_writable, false

set :copy_strategy, :export
# deploy_via:
# * :copy means SCP our files to the remote host from the local host
# * :remote_cache means check it out from the repository (e.g. Github, Bitbucket)
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{fetch(:application)}"
set :keep_releases, 5
set :normalize_asset_timestamps, false

## hipchat deploy announcements
# require 'hipchat/capistrano'
# set :hipchat_token, 'HIPCHAT_API_TOKEN'
# set :hipchat_room_name, 'HIPCHAT_ROOM_NAME'
# set :hipchat_announce, true

## rbenv settings
set :rbenv_type, :user
set :rbenv_ruby, (File.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '.ruby-version'))).strip rescue '2.1.7')
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_setup_shell, true
set :rbenv_install_bundler, true
set :rbenv_install_dependencies, false

## bundler settings
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"

## symlink directories and configuration files
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_files, %w{config/database.yml config/redis.yml}

namespace :deploy do
  task :create_db do
    on roles(:db) do
      execute "cd #{deploy_to}/current && RACK_ENV=#{env} #{rake} db:create"
    end
  end

  task :start do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'start'
        end
      end
    end
  end

  task :stop do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'stop'
        end
      end
    end
  end

  task :restart do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'restart'
        end
      end
    end
  end

  task :reload do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'reload'
        end
      end
    end
  end

  task :upload do
    on roles(:all) do
      fetch(:linked_files, []).each do |_filename|
        upload!(_filename, File.join(shared_path, _filename))
      end
    end
  end
end

namespace :config do
  task :setup_environment do
    on roles(:app) do
      execute "ln -sf #{shared_path}/log #{deploy_to}/current/run"
    end
  end
end

after 'deploy:symlink:release', 'config:setup_environment'
