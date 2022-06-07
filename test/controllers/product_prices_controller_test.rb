require "test_helper"

class ProductPricesControllerTest < ActionDispatch::IntegrationTest
  repo = ProductRepository.new
  
  teardown do
    Timecop.return
  end

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

  test 'price of a video' do
    image = repo.create_video(title: 'Title of Video', content: 'Contents of Video')
    Timecop.travel Time.new(2022, 1, 1) + 5.hours - 1.minute
    assert_equal 9, get_product_price(image[:id])
    Timecop.travel Time.new(2022, 1, 1) + 5.hours + 1.minute
    assert_equal 15, get_product_price(image[:id])
    Timecop.travel Time.new(2022, 1, 1) + 22.hours - 1.minute
    assert_equal 15, get_product_price(image[:id])
    Timecop.travel Time.new(2022, 1, 1) + 22.hours + 1.minute
    assert_equal 9, get_product_price(image[:id])
  end

  private

  def get_product_price(id)
    get product_price_url(id)
    response.parsed_body.to_i
  end
end
