class BookPriceCalculator
  def initialize(isbn_list)
    @isbn_list = isbn_list
  end

  HOT_BOOK_PRICE = 9.99
  def compute(book)
    return HOT_BOOK_PRICE if book[:is_hot]

    price_in_isbn_list = @isbn_list[book[:isbn]]
    return price_in_isbn_list if price_in_isbn_list

    book[:purchase_price] * 1.25
  end
end