require "test_helper"

class ProductPricesControllerTest < ActionDispatch::IntegrationTest
  repo = ProductRepository.new

  test 'price of a book' do
    book = repo.create_book(title: 'Title of Book', content: 'Contents of Book')

    ENV['BOOK_PURCHASE_PRICE']  = '12'
    get product_price_url(book[:id])
    price = response.parsed_body
    assert_equal 15, price.to_i

    ENV['BOOK_PURCHASE_PRICE']  = '16'
    get product_price_url(book[:id])
    price = response.parsed_body
    assert_equal 20, price.to_i

    ENV.delete('BOOK_PURCHASE_PRICE')
  end

  test 'price of an image' do
    image = repo.create_image(title: 'Title of Image', content: 'Contents of Image')
    get product_price_url(image[:id])
    price = response.parsed_body
    assert_equal 7, price.to_i
  end
end
