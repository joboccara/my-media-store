# frozen_string_literal: true
class Products::Book < Products::Product
  attr_accessor :isbn, :is_hot

  def initialize(book)
    super
    @isbn = book.isbn
    @is_hot = book.is_hot
  end
end
