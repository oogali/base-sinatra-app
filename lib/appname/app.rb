require 'bundler'
Bundler.require

require 'appname'

module AppName
  class Application < Sinatra::Application
    REQUIRE_AUTHENTICATION = false

    register Sinatra::StaticAssets

    use Rack::Session::Pool, :path => '/', :key => 'SESSIONID', :sidbits => 128
    use OmniAuth::Builder do
      provider :google_apps, :store => OpenID::Store::Redis.new(settings.redis), :domain => 'appname.com'
    end

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

      def build_validation_error_msg(obj)
        obj.errors.messages.map do |k,v|
          "#{k.to_s} " + v[0..-2].join(', ') + (v.length > 1 ? ' and ' : '') + v.last
        end.flatten.join("<br/>\n")
      end
    end

    before do
      if REQUIRE_AUTHENTICATION
        unless valid_session? or (request.path_info.match(/^\/(login|healthcheck|css\/|js\/)/))
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
      "OK\n"
    end

    get '/' do
      haml :index
    end

    get %r{/css/(\S+)\.css} do |css|
      content_type 'text/css', :charset => 'utf-8'
      sass :"#{css}"
    end
  end
end
