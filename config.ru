require 'dashing'
require 'yaml'

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'

  YAML.load_file('settings.yml').each { |key, value| set key.to_sym, value }

  helpers do
    def protected!
      # Put any authentication code you want in here.
      # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
