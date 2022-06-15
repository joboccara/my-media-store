module Pricers
  class Pricer
    # @param price [Result<Float>]
    # @param params [Hash]
    # @param now [Time]
    # @return [Result<Float>]
    def compute(price, params, now)
      raise "Not implemented!"
    end
  end
end
