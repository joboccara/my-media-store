class PriceCalculator
  def initialize(kind)
    base_price_calculator = case kind
    when 'book'
      if File.exist?(Rails.root.join('isbn_list.csv'))
        _csv_header, *isbn_csv_list = CSV.read(Rails.root.join('isbn_list.csv'))
        isbn_price_list = isbn_csv_list.to_h { |row| [row[0], row[1].to_f] }
      end
      BookPriceCalculator.new(isbn_price_list || {})
    when 'image' then ImagePriceCalculator.new
    when 'video' then VideoPriceCalculator.new
    end

    @calculator = PremiumCalculator.new(base_price_calculator)
  end

  def compute(product)
    @calculator.compute product
  end
end