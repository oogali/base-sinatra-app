require 'bundler'
Bundler.require

require 'appname'

module AppName
  class Application < Sinatra::Application
    REQUIRE_AUTHENTICATION = false

    register Sinatra::StaticAssets

    configure :development do
      enable :show_settings
    end

    use Rack::Session::Pool, :path => '/', :key => 'SESSIONID', :sidbits => 128
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
        render :haml, page, options.merge!(:layout => false), { :partial => true }
      end

      def is_partial?
        locals[:partial] == true
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

    get '/login' do
      body { haml :login }
    end

    post '/login' do
      unless authenticate!(params[:email], params[:passwd])
        flash[:error] = 'Sorry, you entered an invalid e-mail address and/or password.'
        return redirect '/login'
      end

      redirect session[:to] ? session.delete(:to) : '/'
    end

    get '/logout' do
      session.destroy
      redirect '/login'
    end

    %w(get post).each do |method|
      send(method, "/auth/:provider/callback") do
        self.current_user = Db::User.sso_login env['omniauth.auth']
        redirect '/'
      end
    end

    get '/healthcheck' do
      body { "OK\n" }
    end

    get '/' do
      body { haml :index }
    end

    get %r{/css/(\S+)\.css} do |css|
      content_type 'text/css', :charset => 'utf-8'
      body { sass :"#{css}" }
    end
  end
end
