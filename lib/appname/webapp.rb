require 'rubygems'
require 'sinatra'
require 'sinatra/async'
require 'sinatra/settings'
require 'haml'
require 'rack-flash'
require 'appname'

module AppName
  class Application < Sinatra::Application
    register Sinatra::Async
    configure :development do
      register Sinatra::Settings
      register Sinatra::Reloader
      enable :show_settings
    end
    use Rack::Session::Pool
    use Rack::Flash

    aget '/' do
      body { haml :index }
    end

    aget %r{/css/(default|reset)\.css} do |css|
      content_type 'text/css', :charset => 'utf-8'
      body { sass :"#{css}" }
    end
  end
end
