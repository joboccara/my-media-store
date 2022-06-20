# frozen_string_literal: true
module Pricing
  class Pricer
    def price(product)
      case product.kind
      when 'Book'
        Pricing::CompositeStrategy.new(
          pricing_rules: [BookPricer.new(ENV['BOOK_PURCHASE_PRICE'].to_f, Time.now), PremiumProduct.new]
        ).call(product)
      when 'Image'
        ImagePricer.new.call(product)
      when 'Video'
        Pricing::CompositeStrategy.new(
          pricing_rules: [VideoPricer.new(Time.now), PremiumProduct.new]
        ).call(product)
      else
        raise NotImplementedError, 'unknown product kind'
      end
    end
  end
end
