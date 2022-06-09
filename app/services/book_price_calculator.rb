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

  def parse_attribute(key, value)
    case key
    when 'purchase_price' then value.to_f
    when 'is_hot' then value == 'true'
    else value
    end
  end
end