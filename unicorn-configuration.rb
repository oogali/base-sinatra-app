worker_processes 2
listen 18001, :tcp_nodelay => true

working_directory File.dirname(__FILE__)
stdout_path 'run/unicorn.log'
stderr_path 'run/unicorn.log'
pid 'run/server.pid'

preload_app false

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
