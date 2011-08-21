$: << File.dirname(__FILE__) + '/lib' unless $:.include? File.dirname(__FILE__) + '/lib'

require 'rake'
require 'appname/appname'
require 'sinatra/activerecord/rake'
require 'cucumber/rake/task'

namespace :server do
  task :start do
    system "thin -s 1 -C config.yml -R config.ru start"
  end

  task :stop do
    system "thin -s 1 -C config.yml -R config.ru stop"
  end
end

desc 'Run Cucumber tests'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

desc 'Start the web application'
task :start => [ 'server:start' ]

desc 'Stop the web application'
task :stop => [ 'server:stop' ]

desc 'Restart the web application'
task :restart => [ 'server:stop', 'server:start' ]
task :default do
  puts
  puts 'rake <action>'
  puts '* valid actions: start, stop, restart'
  puts
end
