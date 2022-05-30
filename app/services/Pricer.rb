class Pricer
  def get_price(product)
    if product.kind == 'book'
      price_book(product.page_count)
    elsif product.kind == 'image'
      price_image(product.width, product.height)
    elsif product.kind == 'video'
      price_video(product.duration)
    else
      raise "Unknown product kind #{product.kind.inspect}"
    end
  end

  def price_book(page_count)
    page_count.to_f / 10
  end

  def price_image(width, height)
    (width + height).to_f / 1000
  end

  def price_video(duration)
    duration.to_f / 60
  end
end
