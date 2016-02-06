$: << File.dirname(__FILE__) + '/lib' unless $:.include? File.dirname(__FILE__) + '/lib'

require 'rake'
require 'sinatra/activerecord/rake'

# make sure our environment variables are set for both rack and rails
ENV['RACK_ENV'] = ENV['RAILS_ENV'] if ENV['RAILS_ENV'] and not ENV['RACK_ENV']
ENV['RAILS_ENV'] = ENV['RACK_ENV'] if ENV['RACK_ENV'] and not ENV['RAILS_ENV']

# fallback to development if no environment is set
ENV['RAILS_ENV'] = ENV['RACK_ENV'] = 'development' if not ENV['RAILS_ENV'] and not ENV['RACK_ENV']

namespace :server do
  ROOT = File.dirname(__FILE__)
  PIDFILE = File.join(ROOT, 'run/server.pid')

  def get_pid
    unless File.exists? PIDFILE
      puts 'Server is not running'
      return nil
    end

    File.read(PIDFILE).to_i
  end

  def send_signal(pid, signal = :INT)
    Process.kill signal, pid
  end

  task :start do
    system "cd #{ROOT} && bundle exec unicorn -c #{ROOT}/unicorn-configuration.rb -D"
  end

  task :stop do
    pid = get_pid
    send_signal pid if pid
  end
end

namespace :db do
  require File.join(File.dirname(__FILE__), 'setup', 'postgres.rb')
  require 'appname/db'
end

namespace :debug do
  task :database do
    system "bundle exec pry -I. -I#{File.dirname(__FILE__) + '/lib/'} -rsetup/postgres -rappname"
  end

  task :test_connect do
    require File.join(File.dirname(__FILE__), 'setup', 'postgres.rb')
    require 'appname/db'

    ENV['RACK_ENV'] = 'test'
    ENV['RAILS_ENV'] = 'test'
    ActiveRecord::Tasks::DatabaseTasks.env = :test
    ActiveRecord::Base.establish_connection(:test)
  end
end

desc 'Start the web application'
task :start => [ 'server:start' ]

desc 'Stop the web application'
task :stop => [ 'server:stop' ]

desc 'Start the Interactive Ruby interpreter (for ActiveRecord-troubleshooting)'
task :irb => [ 'debug:database' ]
task :pry => [ 'debug:database' ]

desc 'Restart the web application'
task :restart => [ 'server:stop', 'server:start' ]

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  desc 'Run RSpec tests'
  task :test => [ 'debug:test_connect', 'db:purge', 'db:migrate', 'db:test:prepare', 'db:seed', :spec ]
rescue LoadError
  desc 'Tests currently unavailable'
  task :test do
    puts 'Tests are not available because one or more test dependencies are unavailable,'
    puts 'run the "bundle install" command without excluding the development group.'
  end
end

task :default do
  puts
  puts 'rake <action>'
  puts '* valid actions: start, stop, restart'
  puts
end
