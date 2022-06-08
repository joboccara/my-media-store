class ProductPricesController < ApplicationController
  def show
    products = ProductRepository.new
    product = products.get_product(params[:id])
    price = case product[:kind]
    when 'book'
      if File.exist?(Rails.root.join('isbn_list.csv'))
        _csv_header, *isbn_csv_list = CSV.read(Rails.root.join('isbn_list.csv'))
        isbn_price_list = isbn_csv_list.to_h { |row| [row[0], row[1].to_f] }
      end
      BookPriceCalculator.new(isbn_price_list || {}).compute(product)
    when 'image' then ImagePriceCalculator.new.compute(product)
    when 'video' then VideoPriceCalculator.new.compute(product)
    end
    render json: price
  end
end
