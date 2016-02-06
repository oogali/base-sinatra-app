if ENV['CI']
  begin
    require 'coveralls'
  rescue LoadError
  else
    Coveralls.wear!
  end
end

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)
require 'webmock/rspec'
require 'rack/test'
require 'database_cleaner'

Dir[File.join(File.dirname(__FILE__), '../setup', "*.rb")].each { |file| require file }
require File.join(File.dirname(__FILE__), '../lib', 'appname.rb')

ENV['RACK_ENV'] = 'test'
set :environment, :test
set :run, :false
set :raise_errors, :true
set :logging, :false
set :root, File.expand_path(File.join(File.dirname(__FILE__), '../'))

RSpec.configure do |c|
  c.include Rack::Test::Methods
end

def app
  @app ||= AppName::Application
end

at_exit { exit }
