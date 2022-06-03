# frozen_string_literal: true
class ProductPricer
  VIDEO_PRICE_RANGES = [
    { from: 0, to: 8, price: 7.99 },
    { from: 8, to: 18, price: 12 },
    { from: 18, to: 24, price: 14.99 },
  ]

  def compute(category, product_attributes)
    # factory to initialize pricing strategy
    # product attributes:
    #   can be a Hash a step 1, then need a factory to parse attributes to a Struct/class.
    #   Maybe a from Item and a from params for the simulator
    price(category, product_attributes)
  end

  private

  # TODO introduce PricingStrategy classes + factory
  def price(category, product_attributes)
    case category
    when 'book'
      ENV['BOOK_PRICE'].to_i
    when 'video'
      hour = Time.zone.now.hour % 24
      price_range = VIDEO_PRICE_RANGES.find do |range|
        hour >= range[:from] && hour < range[:to]
      end
      raise "range not found for current hour=#{hour}" if price_range.nil?
      product_attributes[:title].ends_with?('Premium') ? (price_range[:price] + 5).round(2) : price_range[:price]
    else
      raise 'Unknown product category'
    end
  end
end
