class PremiumCalculator
  def initialize(base_price_calculator)
    @base_price_calculator = base_price_calculator
  end

  def compute(product)
    base_price = @base_price_calculator.compute(product)
    premium_product = product[:title].present? && product[:title].downcase.include?('premium')
    premium_price = premium_product ? base_price * 1.05 : base_price
  end

  def expected_attributes
    @base_price_calculator.expected_attributes # :title attribute is optional
  end

  def parse_attribute(key, value)
    @base_price_calculator.parse_attribute(key, value)
  end
end
