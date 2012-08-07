module Alexa
  module Utils
    # TODO: simplify
    def safe_retrieve(hash, *keys)
      if hash.kind_of?(Hash) && hash.has_key?(keys.first) && keys.size > 1
        Alexa::Utils.safe_retrieve(hash[keys.first], *keys[1..-1])
      elsif hash.kind_of?(Hash) && hash.has_key?(keys.first) && keys.size == 1
        hash[keys.first]
      else
        nil
      end
    end

    def camelize(string)
      string.split("_").map { |w| w.capitalize }.join
    end

    module_function :safe_retrieve, :camelize
  end
end
