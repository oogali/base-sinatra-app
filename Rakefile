$: << File.dirname(__FILE__) + '/lib' unless $:.include? File.dirname(__FILE__) + '/lib'

require 'rake'
require 'cucumber/rake/task' if ENV['RACK_ENV'] == 'test'
require 'sinatra/activerecord/rake'

# load our setup routines (sql, redis, etc), before loading our app
Dir[File.join(File.dirname(__FILE__), 'setup', "*.rb")].each { |file| require file }
require 'appname'

# set environment...
set :environment, ENV['RACK_ENV'] if ENV['RACK_ENV'] and settings.environment != ENV['RACK_ENV']

# in case we're using any brain-damaged rails gems
ENV['RAILS_ENV'] = ENV['RACK_ENV']

namespace :server do
  task :start do
    system "thin -s 1 -C config.yml -R config.ru start"
  end

  task :stop do
    system "thin -s 1 -C config.yml -R config.ru stop"
  end
end

namespace :debug do
  task :database do
    system "bundle exec irb -I. -I#{File.dirname(__FILE__) + '/lib/'} -rsetup/postgres -rappname"
  end
end

if ENV['RACK_ENV'] == 'test'
  Cucumber::Rake::Task.new do |t|
    t.cucumber_opts = %w{--format pretty}
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
task :default do
  puts
  puts 'rake <action>'
  puts '* valid actions: start, stop, restart'
  puts
end

desc 'Run application unit tests'
task :test => [ 'cucumber' ]
