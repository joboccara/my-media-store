class PriceCalculator
  # @param catalog [ProductCatalog]
  # @return [PriceCalculator]
  def self.default(catalog)
    PriceCalculator.new([
                          Pricers::BookPricer.new(catalog),
                          Pricers::ImagePricer.new,
                          Pricers::VideoPricer.new,
                          Pricers::PremiumPricer.new(1.05)
                        ])
  end

  # @param pricers [Array<Pricer>]
  # @return [PriceCalculator]
  def initialize(pricers)
    @pricers = pricers
  end

  # @param params [Hash]
  # @param now [Time]
  # @return [Result<Float>]
  def price(params, now)
    @pricers.inject(Result.pending) { |price, pricer| pricer.compute(price, params, now) }
  end
end
