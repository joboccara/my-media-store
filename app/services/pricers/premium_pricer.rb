module Pricers
  class PremiumPricer < Pricer
    # @param percentage [Float]
    # @return [PremiumPricer]
    def initialize(percentage)
      @percentage = percentage
    end

    # @param price [Result<Float>]
    # @param params [Hash]
    # @param now [Time]
    # @return [Result<Float>]
    def compute(price, params, now)
      is_premium = (params[:title] || '').downcase.include?('premium')
      price.then { |p| price_premium(p, is_premium) }
    end

    private

    # @param is_premium [Boolean]
    # @param price [Float]
    # @return [Float]
    def price_premium(price, is_premium)
      if is_premium
        price * @percentage
      else
        price
      end
    end
  end
end
