module AppName
  class Application < Sinatra::Application
    if $redis and settings.development?
      require 'memory_profiler'
      require 'flamegraph'
      require 'rack-mini-profiler'
      use Rack::MiniProfiler

      Rack::MiniProfiler.config.position = 'right'
      Rack::MiniProfiler.config.skip_schema_queries = true
      Rack::MiniProfiler.config.storage_options = $redis.client.options
      Rack::MiniProfiler.config.storage = Rack::MiniProfiler::RedisStore
    end
  end
end
