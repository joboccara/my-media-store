class ProductPricesController < ApplicationController
  IMAGE_FIXED_PRICE = 7
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
    when 'image' then IMAGE_FIXED_PRICE
    when 'video' then (5 <= Time.now.hour && Time.now.hour < 22) ? 15 : 9
    end
    render json: price
  end
end
