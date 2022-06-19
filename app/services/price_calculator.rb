class PriceCalculator
  # @param catalog [ProductCatalog]
  # @return [PriceCalculator]
  def self.default(catalog)
    PriceCalculator.new([
                          Pricing::Book.new(catalog),
                          Pricing::Image.new,
                          Pricing::Video.new,
                          Pricing::Weekday.new(0.4),
                          Pricing::Premium.new(0.05)
                        ])
  end

  # @param rules [Array<Pricing::Rule>]
  # @return [PriceCalculator]
  def initialize(rules)
    @rules = rules
  end

  # @param params [Hash]
  # @param now [Time]
  # @return [Result<Float>]
  def price(params, now)
    @rules.reduce(Result.pending) do |price, rule|
      if rule.apply?(params)
        rule.parse(params).and_then { |p| rule.compute(price, p, now) }
      else
        price
      end
    end
  end
end
