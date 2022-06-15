class ProductPricer
  # @param catalog [ProductCatalog]
  # @param now [Time]
  # @return [ProductPricer]
  def initialize(catalog, now)
    @catalog = catalog
    @now = now
  end

  # @param product [ProductDto]
  # @return [Float]
  def compute(product)
    base_price = price_product(product, @catalog, @now)
    price_premium(base_price, product.title)
  end

  private

  # @param product [BookDto, ImageDto, VideoDto]
  # @param now [Time]
  # @return [Float]
  def price_product(product, catalog, now)
    if product.kind == 'book'
      price_book(product.purchase_price, product.is_hot, catalog.get_price(product.isbn), now)
    elsif product.kind == 'image'
      price_image(product.width, product.height, product.source, product.format)
    elsif product.kind == 'video'
      price_video(product.duration, product.quality, now)
    else
      raise "Unknown product kind #{product.kind.inspect}"
    end
  end

  # @param purchase_price [Float]
  # @param is_hot [Boolean]
  # @param catalog_price [Float, Nil]
  # @param now [Time]
  # @return [Float]
  def price_book(purchase_price, is_hot, catalog_price, now)
    return catalog_price unless catalog_price.nil?
    return 9.99 if is_hot && now.on_weekday?
    purchase_price * 1.25
  end

  # @param width [Integer]
  # @param height [Integer]
  # @param source [String]
  # @param format [String]
  # @return [Float]
  def price_image(width, height, source, format)
    pixels = width * height
    if source == 'NationalGeographic'
      0.02 * pixels / 9600
    elsif source == 'Getty'
      return 10.to_f if format == 'raw'
      return 1.to_f if pixels <= 1280 * 720
      return 3.to_f if pixels <= 1920 * 1080
      5.to_f
    else
      7.to_f
    end
  end

  # @param duration [Integer]
  # @param quality [String]
  # @param now [Time]
  # @return [Float]
  def price_video(duration, quality, now)
    started_minutes = 1 + duration / 60
    base_price = if quality == '4k'
                   0.08 * duration
                 elsif quality == 'FullHD'
                   3.to_f * started_minutes
                 elsif quality == 'SD'
                   [10, started_minutes].min.to_f
                 else
                   15.to_f
                 end

    5 <= now.hour && now.hour < 22 ? base_price : base_price * 0.6
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
