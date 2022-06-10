class PriceCalculator
  class UnknownKindError < StandardError; end

  def initialize(kind)
    base_price_calculator = case kind
    when 'book'
      isbn_prices_path = Rails.root.join('app/assets/config/isbn_prices.csv')
      if File.exist?(isbn_prices_path)
        _csv_header, *isbn_csv_list = CSV.read(isbn_prices_path)
        isbn_price_list = isbn_csv_list.to_h { |row| [row[0], row[1].to_f] }
        BookPriceCalculator.new(isbn_price_list)
      else
        BookPriceCalculator.new({})
      end
    when 'image' then ImagePriceCalculator.new
    when 'video' then VideoPriceCalculator.new
    else raise "Unknown item kind #{item.kind}"
    end

    raise UnknownKindError, "cannot price product #{kind.nil? ? "with no kind" : "of kind #{kind}"}" unless base_price_calculator

    @calculator = PremiumCalculator.new(base_price_calculator)
  end

  def compute(product)
    @calculator.compute(product)
  end

  def expected_attributes
    @calculator.expected_attributes
  end

  def parse_attribute(key, value)
    @calculator.parse_attribute(key, value)
  end
end
