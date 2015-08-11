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