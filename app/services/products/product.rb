# frozen_string_literal: true
class Products::Product
  attr_accessor :price, :title, :content, :kind, :id
  class << self
    def from_product(stored_product)
      case stored_product.kind
      when 'Book'
        Products::Book.new(stored_product)
      when 'Image'
        Products::Image.new(stored_product)
      when 'Video'
        Products::Video.new(stored_product)
      else
        binding.pry
        raise "unknown product kind: #{stored_product.class}"
      end
    end
  end

  def initialize(store_product)
    @id = store_product.id
    @kind = store_product.kind
    @title = store_product.title
    @content = store_product.content
  end

  def with_price(price)
    @price = price
    self
  end
end
