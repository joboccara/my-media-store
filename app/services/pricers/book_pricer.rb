module Pricers
  class BookPricer < Pricer
    # @param catalog [ProductCatalog]
    # @return [BookPricer]
    def initialize(catalog)
      @catalog = catalog
    end

    # @param price [Result<Float>]
    # @param params [Hash]
    # @param now [Time]
    # @return [Result<Float>]
    def compute(price, params, now)
      return price unless params[:kind] == 'book'
      return Result.failure('BookPricer should be first') unless price.pending?
      parse_params(params).then { |p| price_book(p[:purchase_price], p[:is_hot], @catalog.get_price(params[:isbn]), now) }
    end

    private

    # @param params [Hash]
    # @return [Result<Hash>]
    def parse_params(params)
      required_attrs = [:isbn, :purchase_price]
      missing_attrs = required_attrs.filter { |attr| params[attr].nil? }
      if missing_attrs.length > 0
        Result.failure("missing parameters for pricing books: #{missing_attrs.sort.join(', ')}")
      else
        Result.success({
                         isbn: params[:isbn].to_s,
                         purchase_price: params[:purchase_price].to_f,
                         is_hot: params[:is_hot] == true || params[:is_hot] == 'true'
                       })
      end
    end

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
