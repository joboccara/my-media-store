require "test_helper"

class ProductPricesControllerTest < ActionDispatch::IntegrationTest
  repo = ProductRepository.new
  
  teardown do
    Timecop.return
  end

  test 'price of a book' do
    book = repo.create_book(title: 'Title of Book', isbn: '1', purchase_price: 10, is_hot: false)

    ENV['BOOK_PURCHASE_PRICE']  = '12'
    assert_equal 15, get_product_price(book[:id])

    ENV['BOOK_PURCHASE_PRICE']  = '16'
    assert_equal 20, get_product_price(book[:id])

    ENV.delete('BOOK_PURCHASE_PRICE')
  end

  test 'price of an image' do
    image = repo.create_image(title: 'Title of Image', width: 800, height: 600, source: 'unknown', format: 'jpg')
    assert_equal 7, get_product_price(image[:id])
  end

  test 'price of a video' do
    image = repo.create_video(title: 'Title of Video', duration: 12, quality: 'HD')
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
