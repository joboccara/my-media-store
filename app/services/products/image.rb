# frozen_string_literal: true
class Products::Image < Products::Product
  attr_accessor :width, :height, :source, :format

  def initialize(book)
    super
    @width = book.width
    @height = book.height
    @source = book.source
    @format = book.format
  end
end
