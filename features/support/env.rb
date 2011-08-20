require 'rack/builder'
require 'capybara/cucumber'

class AppNameWorld
  Capybara.app = eval "Rack::Builder.new {( " + File.read(File.dirname(__FILE__) + '/../../config.ru') + "\n )}"
  include Capybara
end

World { AppNameWorld.new }
