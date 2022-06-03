# frozen_string_literal: true
class ProductCatalog
  VIDEO_PRICE_RANGES = [
    { from: 0, to: 8, price: 7.99 },
    { from: 8, to: 18, price: 12 },
    { from: 18, to:24, price: 14.99 },
  ]

  def call
    Item.all.map do |item|
      product_with_price(item)
    end
  end

  def product_with_price(item)
    {
      title: item.title,
      content: item.content,
      price: price(item),
    }
  end

  # TODO introduce PricingStrategy classes + factory
  def price(item)
    case item.kind
    when 'book'
      ENV['BOOK_PRICE'].to_i
    when 'video'
      hour = Time.zone.now.hour % 24
      price_range = VIDEO_PRICE_RANGES.find do |range|
        hour >= range[:from] && hour < range[:to]
      end
      raise "range not found for current hour=#{hour}" if price_range.nil?
      item.title.ends_with?('Premium') ? (price_range[:price] + 5).round(2) : price_range[:price]
    else
      raise 'Unknown item kind'
    end
  end
end
