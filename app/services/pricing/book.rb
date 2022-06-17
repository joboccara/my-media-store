module Pricing
  class Book < Rule
    ParamsDto = Struct.new(:purchase_price, :is_hot, :isbn)

    # @param catalog [ProductCatalog]
    # @return [Book]
    def initialize(catalog)
      @catalog = catalog
    end

    # @param params [Hash]
    # @return [Boolean]
    def apply?(params)
      params[:kind] == 'book'
    end

    # @param params [Hash]
    # @return [Result<ParamsDto>]
    def parse(params)
      Parser::Struct.new(
        isbn: Parser::Text.new(min: 10, max: 13, regex: /[0-9-]+/),
        purchase_price: Parser::Number.new(&:to_f),
        is_hot: Parser::Bool.new.optional(default: false),
      ).map { |p| ParamsDto.new(p[:purchase_price], p[:is_hot], p[:isbn]) }.run(params)
    end

    # @param price [Result<Float>]
    # @param params [ParamsDto]
    # @param now [Time]
    # @return [Result<Float>]
    def compute(price, params, now)
      return Result.failure('Book pricing rule should be first') unless price.pending?
      Result.success(price_book(params.purchase_price, params.is_hot, @catalog.get_price(params.isbn), now))
    end

    private

    # @param purchase_price [Float]
    # @param is_hot [Boolean]
    # @param catalog_price [Float, nil]
    # @param now [Time]
    # @return [Float]
    def price_book(purchase_price, is_hot, catalog_price, now)
      return catalog_price unless catalog_price.nil?
      return 9.99 if is_hot && now.on_weekday?
      purchase_price * 1.25
    end
  end
end
