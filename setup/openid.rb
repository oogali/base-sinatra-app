require 'sinatra'
require 'openid/fetchers'

OpenID.fetcher.ca_file = File.join settings.root, 'ca-certificates.crt'
