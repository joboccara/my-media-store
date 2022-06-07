require "test_helper"

class ProductPricesControllerTest < ActionDispatch::IntegrationTest
  repo = ProductRepository.new

  test 'price of a book' do
    ENV['BOOK_PURCHASE_PRICE']  = '12'
    book = repo.create_book(title: 'Title of Book', content: 'Contents of Book')

    get product_price_url(book[:id])

    price = response.parsed_body
    assert_equal 15, price.to_i
  end
end
