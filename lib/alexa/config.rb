require "singleton"

module Alexa
  class Config
    include Singleton
    attr_reader :access_key_id, :secret_access_key

    def access_key_id=(key)
      puts "Depracation warning: Alexa.config.access_key_id= is deprecated. Use Alexa.access_key_id="
      Alexa.access_key_id = key
    end

    def secret_access_key=(key)
      puts "Depracation warning: Alexa.config.secret_access_key= is deprecated. Use Alexa.secret_access_key="
      Alexa.secret_access_key = key
    end
  end

  def self.config
    if block_given?
      yield Config.instance
    end
    Config.instance
  end
end
