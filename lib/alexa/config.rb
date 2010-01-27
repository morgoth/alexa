require 'singleton'

module Alexa
  class Config
    include Singleton
    attr_accessor :access_key_id, :secret_access_key
  end

  def self.config
    if block_given?
      yield Config.instance
    end
    Config.instance
  end
end