class PricingStrategies::BooksStrategy

  @margin = 25

  # @param [Item] item
  def supports(item)
    item.kind == 'book' && !item.is_hot?
  end

  def priority
    0
  end

  # @param [Item] item
  # @return float
  def compute(item)
    apply_margin item.purchased_price
  end
  
  private
  # @param [Float] value
  def apply_margin(value)
    (1+ @margin/100) * value
  end
end