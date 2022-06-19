module Pricing
  class Rule
    # @param params [Hash]
    # @return [Boolean]
    def apply?(params)
      raise NotImplementedError
    end

    # @param params [Hash]
    # @return [Result<T>]
    def parse(params)
      raise NotImplementedError
    end

    # @param price [Result<Float>]
    # @param params [T]
    # @param now [Time]
    # @return [Result<Float>]
    def compute(price, params, now)
      raise NotImplementedError
    end
  end
end
