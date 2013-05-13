$: << File.dirname(__FILE__) + '/lib' unless $:.include? File.dirname(__FILE__) + '/lib'

require 'rake'
require 'sinatra/activerecord/rake'

# load our setup routines (sql, redis, etc), before loading our app
Dir[File.join(File.dirname(__FILE__), 'setup', "*.rb")].each { |file| require file }
require 'appname'

# set environment...
set :environment, ENV['RACK_ENV'] if ENV['RACK_ENV'] and settings.environment != ENV['RACK_ENV']

# in case we're using any brain-damaged rails gems
ENV['RAILS_ENV'] = ENV['RACK_ENV']

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

namespace :debug do
  task :database do
    system "bundle exec irb -I. -I#{File.dirname(__FILE__) + '/lib/'} -rsetup/postgres -rappname"
  end
end

desc 'Start the web application'
task :start => [ 'server:start' ]

desc 'Stop the web application'
task :stop => [ 'server:stop' ]

desc 'Start the Interactive Ruby interpreter (for ActiveRecord-troubleshooting)'
task :irb => [ 'debug:database' ]

desc 'Restart the web application'
task :restart => [ 'server:stop', 'server:start' ]

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  desc 'Run RSpec tests'
  task :test => :spec
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
