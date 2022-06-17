# frozen_string_literal: true
class BookPricer
  def initialize(book_purchase_price)
    @book_purchase_price = book_purchase_price
  end

  def call
    @book_purchase_price * 1.25
  end
end
