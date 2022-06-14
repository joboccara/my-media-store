class BookPriceCalculator
  def initialize(isbn_prices)
    @isbn_prices = isbn_prices
  end

  HOT_BOOK_PRICE = 9.99
  def compute(book)
    price_in_isbn_prices = @isbn_prices[book[:isbn]]
    return price_in_isbn_prices if price_in_isbn_prices

    return HOT_BOOK_PRICE if book[:is_hot] && Time.now.on_weekday?

    book[:purchase_price] * 1.25
  end

  def expected_attributes
    [:isbn, :purchase_price] # :is_hot attribute is optional
  end

  def parse_attribute(key, value)
    case key
    when 'purchase_price' then value.to_f
    when 'is_hot' then value == 'true'
    else value
    end
  end
end
