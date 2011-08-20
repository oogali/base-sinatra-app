$: << File.dirname(__FILE__) + '/lib' unless $:.include? File.dirname(__FILE__) + '/lib'

require 'rubygems'
require 'active_record'
require 'redis'
require 'redis/objects'
require 'sinatra'
require 'sinatra/activerecord'
require 'haml'
require 'appname/appname'

# set working directory
working = File.expand_path File.dirname(__FILE__)
set :root, working

# set haml to html5 mode, disable sinatra from autostart
set :haml, :format => :html5
disable :run, :reload

# redirect logs
log = File.new(File.join(working, 'run', 'sinatra.log'), 'a')
$stdout.reopen(log)
$stderr.reopen(log)

# establish database connection
set :database, 'postgres://localhost/newapp' if !ENV['DATABASE_URL']
p database.connection

# establish redis connection
redis = URI.parse(ENV['REDIS_URL'] || 'redis://127.0.0.1:6379')
Redis::Objects.redis = Redis.new(
  :host => redis.host,
  :port => redis.port || 6379,
  :password => redis.password,
  :db => redis.path
)
p Redis::Objects.redis

# load core class and run
run AppName::Application
