class ProductPricer
  # @param book_purchase_price [Float]
  # @param now [Time]
  # @return [ProductPricer]
  def initialize(book_purchase_price, now)
    @book_purchase_price = book_purchase_price
    @now = now
  end

  # @param product [ProductDto]
  # @return [Float]
  def compute(product)
    base_price = price_product(product.kind, @book_purchase_price, @now)
    price_premium(base_price, product.title)
  end

  private

  # @param kind [String]
  # @param book_purchase_price [Float]
  # @param now [Time]
  # @return [Float]
  def price_product(kind, book_purchase_price, now)
    if kind == 'book'
      price_book(book_purchase_price)
    elsif kind == 'image'
      price_image
    elsif kind == 'video'
      price_video(now)
    else
      raise "Unknown product kind #{kind.inspect}"
    end
  end

  # @param purchase_price [Float]
  # @return [Float]
  def price_book(purchase_price)
    purchase_price * 1.25
  end

  # @return [Float]
  def price_image
    7.to_f
  end

  # @param now [Time]
  # @return [Float]
  def price_video(now)
    (5 <= now.hour && now.hour < 22 ? 15 : 9).to_f
  end

  # @param title [String]
  # @param price [Float]
  # @return [Float]
  def price_premium(price, title)
    if title.downcase.include?('premium')
      price * 1.05
    else
      price
    end
  end
end
