$: << File.dirname(__FILE__) + '/lib' unless $:.include? File.dirname(__FILE__) + '/lib'

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'appname'

# set working directory
working = File.expand_path File.dirname(__FILE__)
set :root, working

# set haml to html5 mode, disable sinatra from autostart
set :haml, :format => :html5
disable :run, :reload

# redirect logs if we're *not* running a test (presence of RACK_ENV)
if ENV['RACK_ENV']
  log = File.new(File.join(working, 'run', 'sinatra.log'), 'a')
  $stdout.reopen(log)
  $stderr.reopen(log)
end

# map urls
map '/' do
  run AppName::Application
end
