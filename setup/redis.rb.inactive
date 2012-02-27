require 'redis/connection/hiredis'
require 'redis'
require 'redis/objects'

# establish redis connection
redis = URI.parse(ENV['REDIS_URL'] || 'redis://127.0.0.1:6379')
Redis::Objects.redis = Redis.new(
  :host => redis.host,
  :port => redis.port || 6379,
  :password => redis.password,
  :db => redis.path
)
puts "#{Redis::Objects.redis.inspect.to_s}\n\n"
