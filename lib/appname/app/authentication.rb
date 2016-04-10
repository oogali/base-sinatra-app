module AppName
  class Application < Sinatra::Application
    REQUIRE_AUTHENTICATION = false

    use OmniAuth::Builder do
      provider :google_apps, :store => OpenID::Store::Redis.new(settings.redis), :domain => 'appname.com'
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
      haml :login 
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
  end
end
