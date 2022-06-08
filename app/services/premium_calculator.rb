class PremiumCalculator
  def initialize(base_price_calculator)
    @base_price_calculator = base_price_calculator
  end

  def compute(product)
    base_price = @base_price_calculator.compute(product)
    premium_product = product[:title].downcase.include? 'premium'
    premium_price = premium_product ? base_price * 1.05 : base_price
  end
end