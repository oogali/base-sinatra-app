set :rails_env, 'staging'
set :rack_env, fetch(:rails_env)

server 'localhost', user: fetch(:application), roles: %w{web app db}

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(publickey)
}
