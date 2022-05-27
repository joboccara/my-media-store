class PricingStrategies::HotBooksStrategy

  @hot_book_fixed_price = 9.99

  # @param [Item] item
  def supports(item)
    item.kind == 'book' && item.is_hot? && Time.now.wday < 6
  end

  def priority
    200
  end

  # @param [Item] item
  def compute(item)
    @hot_book_fixed_price
  end
end