require_relative 'key.rb'


Giphy::Configuration.configure do |config|
  config.version = THE_API_VERSION
  config.api_key = KEY
end
