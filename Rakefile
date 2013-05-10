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
