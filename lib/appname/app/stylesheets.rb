module AppName
  class Application < Sinatra::Application
    get %r{^/css/(\S+)\.css} do |css|
      content_type 'text/css', :charset => 'utf-8'
      sass :"#{css}"
    end
  end
end
