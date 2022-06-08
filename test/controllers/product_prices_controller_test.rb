require "test_helper"
require "csv"

class ProductPricesControllerTest < ActionDispatch::IntegrationTest
  repo = ProductRepository.new
  
  teardown do
    Timecop.return
  end

  test 'price of a book based on purchase price' do
    book1 = repo.create_book(title: 'Title of Book1', isbn: '1', purchase_price: 12, is_hot: false)
    assert_equal 15, get_product_price(book1[:id])

    book2 = repo.create_book(title: 'Title of Book2', isbn: '1', purchase_price: 16, is_hot: false)
    assert_equal 20, get_product_price(book2[:id])
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

      book = repo.create_book(title: 'Title of Book', isbn: '9781603095099', purchase_price: 12, is_hot: false)
      assert_equal 19.99, get_product_price(book[:id])

      book = repo.create_book(title: 'Title of Book', isbn: '1234567890', purchase_price: 16, is_hot: false)
      assert_equal 20, get_product_price(book[:id])
    ensure
      File.delete(Rails.root.join('isbn_list.csv'))
    end
  end

  test 'hot books are fixed during weekdays' do
    book = repo.create_book(title: 'Title of Book', isbn: '9781603095099', purchase_price: 14, is_hot: true)
    Timecop.travel(Time.new(2022, 1, 3)) # Monday
    assert_equal 9.99, get_product_price(book[:id])
    Timecop.travel(Time.new(2022, 1, 4)) # Tuesday
    assert_equal 9.99, get_product_price(book[:id])
    Timecop.travel(Time.new(2022, 1, 5)) # Wednesday
    assert_equal 9.99, get_product_price(book[:id])
    Timecop.travel(Time.new(2022, 1, 6)) # Thursday
    assert_equal 9.99, get_product_price(book[:id])
    Timecop.travel(Time.new(2022, 1, 7)) # Friday
    assert_equal 9.99, get_product_price(book[:id])
  end

  test 'hot books are fixed during weekends' do
    begin
      CSV.open(Rails.root.join('isbn_list.csv'), 'w') do |csv|
        csv << ['ISBN', 'price']
        csv << ['9781603095136', '14.99']
      end
      book = repo.create_book(title: 'Title of Book', isbn: '9781603095099', purchase_price: 14, is_hot: true)
      Timecop.travel(Time.new(2022, 1, 8)) # Saturday
      assert_equal 9.99, get_product_price(book[:id])
      Timecop.travel(Time.new(2022, 1, 9)) # Sunday
      assert_equal 9.99, get_product_price(book[:id])
    ensure
      File.delete(Rails.root.join('isbn_list.csv'))
    end
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
