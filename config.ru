$: << File.dirname(__FILE__) + '/lib' unless $:.include? File.dirname(__FILE__) + '/lib'

require 'rubygems'
require 'bundler'

Bundler.require

# set working directory
working = File.expand_path File.dirname(__FILE__)
set :root, working

# set haml to html5 mode, disable sinatra from autostart
set :haml, :format => :html5
disable :run, :reload

if production?
  # disable built-in exception handling
  set :raise_errors, Proc.new { false }
  set :show_exceptions, false
end

# redirect logs if we're *not* running a test (presence of RACK_ENV)
if ENV['RACK_ENV']
  log = File.new(File.join(working, 'run', 'sinatra.log'), 'a')
  $stdout.reopen(log)
  $stderr.reopen(log)
end

# load our setup routines (sql, redis, etc), before loading our app
Dir[File.join(File.dirname(__FILE__), 'setup', "*.rb")].each { |file| require file }

# load our app
require 'appname'

# map urls
map '/' do
  run AppName::Application
end
