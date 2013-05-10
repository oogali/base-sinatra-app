require 'redis/connection/hiredis'
require 'redis'
require 'redis/objects'
require 'sinatra'

# establish redis connection
redis = URI.parse(ENV['REDIS_URL'] || 'redis://127.0.0.1:6379')
Redis::Objects.redis = Redis.new(
  :host => redis.host,
  :port => redis.port || 6379,
  :password => redis.password,
  :db => redis.path
)

set :redis, redis
