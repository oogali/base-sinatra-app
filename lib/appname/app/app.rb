module AppName
  class Application < Sinatra::Application
    register Sinatra::StaticAssets

    def initialize
      super
    end
  end
end
