module AppName
  class Application < Sinatra::Application
    use Rack::Session::Pool, :path => '/', :key => 'SESSIONID', :sidbits => 128
  end
end
