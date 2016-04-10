module AppName
  class Application < Sinatra::Application
    get '/healthcheck' do
      if  File.exists?(File.join(settings.root, '.maintenance')) or File.exists?('/maintenance')
        halt 503, 'We seem to be in a maintenance period. Be back shortly.'
      end

      "OK\n"
    end
  end
end
