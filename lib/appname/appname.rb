require 'sinatra'
require 'haml'

module AppName
  class Application < Sinatra::Base
    get '/' do
      haml :index
    end

    get %r{/css/(default|reset)\.css} do
      content_type 'text/css', :charset => 'utf-8'
      sass :"#{params[:captures].first}"
    end
  end
end
