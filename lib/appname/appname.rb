require 'sinatra/base'
require 'sinatra/async'
require 'sinatra/settings'
require 'haml'

module AppName
  class Application < Sinatra::Base
    register Sinatra::Async
    register Sinatra::Settings
    enable :show_settings

    aget '/' do
      body { haml :index }
    end

    aget %r{/css/(default|reset)\.css} do
      content_type 'text/css', :charset => 'utf-8'
      body { sass :"#{params[:captures].first}" }
    end
  end
end
