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

  def expected_attributes
    [:isbn, :purchase_price, :is_hot]
  end

  def validate_input(book)
    missing_attributes = expected_attributes - book.keys
    return missing_attributes.empty? ? [true, nil] : [false, "missing parameters for pricing books: #{missing_attributes.join(', ')}"]
  end
end