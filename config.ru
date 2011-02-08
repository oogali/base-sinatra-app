require 'rubygems'
require 'sinatra'
require 'haml'

# set working directory
working = File.dirname(__FILE__)
set :root, working

# set haml to html5 mode, disable sinatra from autostart
set :haml, :format => :html5
disable :run

# redirect logs
log = File.new('sinatra.log', 'a')
$stdout.reopen(log)
$stderr.reopen(log)

# load core class and run
require working + '/appname'
run AppName::Application
