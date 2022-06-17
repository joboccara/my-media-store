# frozen_string_literal: true
class Pricer
  def price(product)
    price = pricing_strategy(product.kind).call
    apply_premium_pricing(price, product.kind, product.title)
  end

  private

  def pricing_strategy(product_kind)
    case product_kind
    when 'book'
      BookPricer.new(ENV['BOOK_PURCHASE_PRICE'].to_f)
    when 'image'
      ImagePricer.new
    when 'video'
      VideoPricer.new(Time.zone.now)
    else
      raise NotImplementedError, 'unknown product kind'
    end
  end

  def apply_premium_pricing(price, product_kind, product_title)
    return price unless product_kind.in? %w[book video]
    return price unless product_title.downcase.include? 'premium'
    price * 1.05
  end
end
