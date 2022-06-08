class ProductPricesController < ApplicationController
  def show
    products = ProductRepository.new
    product = products.get_product(params[:id])
    price = price_calculator(product[:kind]).compute(product)

    render json: price
  end

  private

  def price_calculator(kind)
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

    PremiumCalculator.new(base_price_calculator)
  end
end
