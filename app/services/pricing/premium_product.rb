# frozen_string_literal: true
module Pricing
  class PremiumProduct
    def call(initial_price, product)
      return initial_price unless product.title&.downcase&.include? 'premium'
      initial_price * 1.05
    end
  end
end
