require 'redis/connection/hiredis'
require 'redis'
require 'redis/objects'
require 'sinatra'

# set defaults
_redis = {
  database: 0,
  host: 'localhost',
  port: 6379,
  password: nil
}

if ENV.has_key?('REDIS_URL')
  _uri = URI.parse(ENV['REDIS_URL'])
  _redis[:database] = _uri.path
  _redis[:host] = _uri.host
  _redis[:port] = _uri.port || 6379
  _redis[:password] = _uri.password
else
  # get config file
  config_file = File.expand_path(File.dirname(__FILE__) + '/../config/redis.yml')
  redis_config = YAML.load_file(config_file).deep_symbolize_keys
  _redis = redis_config[settings.environment]
  if _redis == nil
    raise "Could not find a Redis configuration for environment \"#{settings.environment}\""
  end
end

# establish redis connection
redis = Redis::Objects.redis = Redis.new(
  :db => _redis[:database],
  :host => _redis[:host],
  :port => _redis[:port],
  :password => _redis[:password]
)

set :redis, redis
