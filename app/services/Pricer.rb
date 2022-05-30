class Pricer
  def get_price(product)
    if product.kind == 'book'
      product.page_count.to_f / 10
    elsif product.kind == 'image'
      (product.width + product.height).to_f / 1000
    elsif product.kind == 'video'
      product.duration.to_f / 60
    else
      raise "Unknown item kind #{product.kind.inspect}"
    end
  end
end
