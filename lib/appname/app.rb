require 'rubygems'
require 'sinatra'
require 'sinatra/async'
require 'sinatra/reloader' if development?
require 'sinatra/settings' if development?
require 'haml'
require 'rack-flash'
require 'omniauth'
require 'omniauth-google-apps'
require 'openid/store/filesystem'
require 'appname'

module AppName
  class Application < Sinatra::Application
    REQUIRE_AUTHENTICATION = false

    register Sinatra::Async

    configure :development do
      register Sinatra::Settings
      register Sinatra::Reloader
      enable :show_settings
    end

    use Rack::Session::Pool, :path => '/', :secret => 'SET_YOUR_SECRET_SESSION_KEY_HERE', :key => 'SESSIONID', :sidbits => 128
    use Rack::Flash
    use OmniAuth::Builder do
      provider :google_apps, :store => OpenID::Store::Filesystem.new('/tmp/appname'), :domain => 'appname.com'
    end

    def initialize
      super
    end

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

      def partial(page, options = {})
        render :haml, page, options.merge!(:layout => false)
      end
    end

    before do
      if REQUIRE_AUTHENTICATION
        unless valid_session? or (request.path_info.match /^\/(login|healthcheck|css\/|js\/)/)
          session[:to] = request.path == '/login' ? '/' : request.path
          return redirect '/login'
        end
      end
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

    aget '/logout' do
      session.destroy
      redirect '/login'
    end

    %w(get post).each do |method|
      send(method, "/auth/:provider/callback") do
        self.current_user = Db::User.sso_login env['omniauth.auth']
        redirect '/'
      end
    end

    aget '/healthcheck' do
      body { "OK\n" }
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
