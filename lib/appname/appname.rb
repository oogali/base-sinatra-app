require 'sinatra'
require 'sinatra/async'
require 'sinatra/settings'
require 'haml'
require 'appname/dbexample'

module AppName
  class Application < Sinatra::Application
    register Sinatra::Async
    configure :development do
      register Sinatra::Settings
      enable :show_settings
    end

    aget '/' do
      body { haml :index }
    end

    aget %r{/css/(default|reset)\.css} do
      content_type 'text/css', :charset => 'utf-8'
      body { sass :"#{params[:captures].first}" }
    end
  end
end
