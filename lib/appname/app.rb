require 'rubygems'
require 'sinatra'
require 'sinatra/async'
require 'sinatra/reloader' if development?
require 'sinatra/settings' if development?
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

    use Rack::Session::Pool, :path => '/', :secret => 'SET_YOUR_SECRET_SESSION_KEY_HERE', :key => 'SESSIONID', :sidbits => 128
    use Rack::Flash

    helpers do
      def authenticate!(username, password)
        self.current_user = Db::User.authenticate username, password
      end

      def current_user
        session[:user]
      end

      def current_user=(user)
        session[:user] = user
      end

      def valid_session?
        current_user and current_user.id.to_i > 0
      end
    end

    before do
      # unless valid_session? or (request.path_info.match /^\/(login|healthcheck|css\/|js\/)/)
      #   session[:to] = request.path == '/login' ? '/' : request.path
      #   return redirect '/login'
      # end
    end

    aget '/login' do
      body { haml :login }
    end

    post '/login' do
      unless authenticate!(params[:email], params[:passwd])
        flash[:error] = 'Sorry, you entered an invalid e-mail address and/or password.'
        return redirect '/login'
      end

      redirect session[:to] ? session.delete(:to) : '/'
    end
    aget '/' do
      body { haml :index }
    end

    aget %r{/css/(default|reset)\.css} do |css|
      content_type 'text/css', :charset => 'utf-8'
      body { sass :"#{css}" }
    end
  end
end
