require 'rake'

namespace :deploy do
  task :start do
    system "thin -s 1 -C config.yml -R config.ru start"
  end

  task :stop do
    system "thin -s 1 -C config.yml -R config.ru stop"
  end
end

task :start => [ 'deploy:start' ]
task :stop => [ 'deploy:stop' ]
task :restart => [ 'deploy:stop', 'deploy:start' ]
task :default do
  puts 'rake <action>'
  puts '* valid actions: start, stop, restart'
  puts
end
