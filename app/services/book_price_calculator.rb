class BookPriceCalculator
  def initialize(isbn_list)
    @isbn_list = isbn_list
  end

  def compute(book)
    price_in_isbn_list = @isbn_list[book[:isbn]]
    return price_in_isbn_list if price_in_isbn_list
    ENV['BOOK_PURCHASE_PRICE'].to_i * 1.25
  end
end