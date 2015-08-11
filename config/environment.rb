<<<<<<< HEAD
require_relative 'key.rb'


Giphy::Configuration.configure do |config|
  config.version = THE_API_VERSION
  config.api_key = KEY
end
=======
require_relative '../key.rb'
require 'giphy' 
require_relative '../lib/program'

class GiphyApi
  attr_reader :client

  def initialize
    Giphy::Configuration.configure do |config|
      config.api_key = KEY
    end
  end
end
>>>>>>> bc88e0f8ff165aba002164d385edb7f0a1e2afc0
