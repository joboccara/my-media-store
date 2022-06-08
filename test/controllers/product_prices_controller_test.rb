require "test_helper"
require "csv"

class ProductPricesControllerTest < ActionDispatch::IntegrationTest
  repo = ProductRepository.new
  
  teardown do
    Timecop.return
  end

  test 'price of a book in the ISBN list' do
    begin
      CSV.open(Rails.root.join('isbn_list.csv'), 'w') do |csv|
        csv << ['ISBN', 'price']
        csv << ['9781603095136', '14.99']
        csv << ['9781603095099', '19.99']
        csv << ['9781603095143', '9.99']
        csv << ['9781603095051', '19.99']
      end

      book = repo.create_book(title: 'Title of Book', isbn: '9781603095099', purchase_price: 10, is_hot: false)
      assert_equal 19.99, get_product_price(book[:id])

      ENV['BOOK_PURCHASE_PRICE']  = '12'
      book = repo.create_book(title: 'Title of Book', isbn: '1234567890', purchase_price: 10, is_hot: false)
      assert_equal 15, get_product_price(book[:id])
      ENV.delete('BOOK_PURCHASE_PRICE')
    ensure
      File.delete(Rails.root.join('isbn_list.csv'))
    end
  end

  test 'price of a book based on purchase price' do
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
    response.parsed_body.to_f
  end
end
