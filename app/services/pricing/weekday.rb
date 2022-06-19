module Pricing
  class Weekday < Rule
    # @param discount [Float]
    # @return [Weekday]
    def initialize(discount)
      @discount = discount
    end

    # @param params [Hash]
    # @return [Boolean]
    def apply?(params)
      params[:kind] == 'video'
    end

    # @param params [Hash]
    # @return [Result<nil>]
    def parse(params)
      Result.success(nil)
    end

    # @param price [Result<Float>]
    # @param params [nil]
    # @param now [Time]
    # @return [Result<Float>]
    def compute(price, params, now)
      price.then { |p| 5 <= now.hour && now.hour < 22 ? p : p * (1 - @discount) }
    end
  end
end
