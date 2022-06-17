module Pricing
  class Premium < Rule
    ParamsDto = Struct.new(:is_premium)

    # @param raise [Float]
    # @return [Premium]
    def initialize(raise)
      @raise = raise
    end

    # @param params [Hash]
    # @return [Boolean]
    def apply?(params)
      true
    end

    # @param params [Hash]
    # @return [Result<ParamsDto>]
    def parse(params)
      Parser::Struct.new(
        title: Parser::Text.new.optional(default: ''),
      ).map { |p| ParamsDto.new(p[:title].downcase.include?('premium')) }.run(params)
    end

    # @param price [Result<Float>]
    # @param params [ParamsDto]
    # @param now [Time]
    # @return [Result<Float>]
    def compute(price, params, now)
      price.then { |p| price_premium(p, params.is_premium) }
    end

    private

    # @param is_premium [Boolean]
    # @param price [Float]
    # @return [Float]
    def price_premium(price, is_premium)
      if is_premium
        price * (1 + @raise)
      else
        price
      end
    end
  end
end
