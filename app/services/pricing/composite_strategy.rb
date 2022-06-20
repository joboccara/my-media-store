# frozen_string_literal: true
class Pricing::CompositeStrategy
  def initialize(initial_price: nil, pricing_rules:)
    @pricing_rules = pricing_rules
    @initial_price = initial_price
  end

  def call(product)
    price = nil
    @pricing_rules.each do |rule|
      price = price.present? ? rule.call(price, product) : rule.call(product)
    end
    price
  end
end
