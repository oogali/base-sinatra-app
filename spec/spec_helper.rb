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

$LOAD_PATH << File.join(File.dirname(__FILE__), '../')
Dir[File.join(File.dirname(__FILE__), '../setup', "*.rb")].each { |file| require file unless file.include?('setup/raven.rb') }
require File.join(File.dirname(__FILE__), '../lib', 'appname.rb')

require 'shoulda/matchers'
Shoulda::Matchers.configure do |c|
  c.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
  end
end

require 'factory_girl'
FactoryGirl.find_definitions

ENV['RACK_ENV'] = 'test'
ENV['RAILS_ENV'] = 'test'
set :environment, :test
set :run, :false
set :raise_errors, :true
set :logging, :false
set :root, File.expand_path(File.join(File.dirname(__FILE__), '../'))

RSpec.configure do |c|
  c.warnings = false

  dbconfigs = ActiveRecord::Base.configurations
  ActiveRecord::Base.logger.level = ENV['DEBUG'] ? Logger::DEBUG : Logger::INFO
  ActiveRecord::Base.establish_connection(dbconfigs['test'])
  ActiveRecord::Tasks::DatabaseTasks.env = :test
  ActiveRecord::Migration.maintain_test_schema!

  c.include Rack::Test::Methods
  c.include FactoryGirl::Syntax::Methods

  c.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  c.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  c.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  c.after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  c.after(:each) do
    DatabaseCleaner.clean
  end

  c.around do |example|
    DatabaseCleaner.cleaning do
      ActiveRecord::Base.transaction do
        example.run
      end
    end
  end
end

def app
  @app ||= AppName::Application
end

at_exit { exit }
