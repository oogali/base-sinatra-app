require 'appname/db/db'

# load all db classes
Dir[File.join(File.dirname(__FILE__), 'db', '**', '*.rb')].each { |f| require f }
