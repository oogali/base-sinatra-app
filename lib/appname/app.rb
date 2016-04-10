require 'bundler'
Bundler.require

require 'appname'

# load all db classes
Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each { |f| require f }
