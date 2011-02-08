require 'rubygems'
require 'sinatra'
require 'haml'

working = File.dirname(__FILE__)
set :root, working
set :haml, :format => :html5
disable :run

require working + '/appname'

log = File.new('sinatra.log', 'a')
$stdout.reopen(log)
$stderr.reopen(log)

run AppName::Application
