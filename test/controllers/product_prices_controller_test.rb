require "test_helper"
require "csv"

class ProductPricesControllerTest < ActionDispatch::IntegrationTest
  repo = ProductRepository.new
  
  teardown do
    Timecop.return
  end

  test 'price of a book based on purchase price' do
    book1 = repo.create_book(title: 'Title of Book1', isbn: '1', purchase_price: 12, is_hot: false)
    assert_price_equal 15, get_product_price(book1[:id])

    book2 = repo.create_book(title: 'Title of Book2', isbn: '1', purchase_price: 16, is_hot: false)
    assert_price_equal 20, get_product_price(book2[:id])
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
      assert_price_equal 19.99, get_product_price(book[:id])

      book = repo.create_book(title: 'Title of Book', isbn: '1234567890', purchase_price: 16, is_hot: false)
      assert_price_equal 20, get_product_price(book[:id])
    ensure
      File.delete(Rails.root.join('isbn_list.csv'))
    end
  end

  test 'hot books are fixed during weekdays' do
    book = repo.create_book(title: 'Title of Book', isbn: '9781603095099', purchase_price: 14, is_hot: true)
    Timecop.travel(Time.new(2022, 1, 3)) # Monday
    assert_price_equal 9.99, get_product_price(book[:id])
    Timecop.travel(Time.new(2022, 1, 4)) # Tuesday
    assert_price_equal 9.99, get_product_price(book[:id])
    Timecop.travel(Time.new(2022, 1, 5)) # Wednesday
    assert_price_equal 9.99, get_product_price(book[:id])
    Timecop.travel(Time.new(2022, 1, 6)) # Thursday
    assert_price_equal 9.99, get_product_price(book[:id])
    Timecop.travel(Time.new(2022, 1, 7)) # Friday
    assert_price_equal 9.99, get_product_price(book[:id])
  end

  test 'hot books are fixed during weekends' do
    begin
      CSV.open(Rails.root.join('isbn_list.csv'), 'w') do |csv|
        csv << ['ISBN', 'price']
        csv << ['9781603095136', '14.99']
      end
      book = repo.create_book(title: 'Title of Book', isbn: '9781603095099', purchase_price: 14, is_hot: true)
      Timecop.travel(Time.new(2022, 1, 8)) # Saturday
      assert_price_equal 9.99, get_product_price(book[:id])
      Timecop.travel(Time.new(2022, 1, 9)) # Sunday
      assert_price_equal 9.99, get_product_price(book[:id])
    ensure
      File.delete(Rails.root.join('isbn_list.csv'))
    end
  end

  test 'images from NationalGeographic are sold at .02$/9600px' do
    image = repo.create_image(title: 'Title of Image', width: 800, height: 600, source: 'NationalGeographic', format: 'jpg')
    assert_price_equal 1, get_product_price(image[:id])
  end

  test 'images from Getty are sold at 1 when below 1280x720' do
    image = repo.create_image(title: 'Title of Image', width: 1280, height: 720, source: 'Getty', format: 'jpg')
    assert_price_equal 1, get_product_price(image[:id])
  end

  test 'images from Getty are sold at 3 when below 1920x1080' do
    image1 = repo.create_image(title: 'Title of Image1', width: 1281, height: 720, source: 'Getty', format: 'jpg')
    assert_price_equal 3, get_product_price(image1[:id])

    image2 = repo.create_image(title: 'Title of Image2', width: 1920, height: 1080, source: 'Getty', format: 'jpg')
    assert_price_equal 3, get_product_price(image2[:id])
  end

  test 'images from Getty are sold at 5 when above 1920x1080' do
    image = repo.create_image(title: 'Title of Image', width: 1921, height: 1080, source: 'Getty', format: 'jpg')
    assert_price_equal 5, get_product_price(image[:id])
  end

  test 'images from Getty in raw format are at 10' do
    image1 = repo.create_image(title: 'Title of Image1', width: 800, height: 600, source: 'Getty', format: 'raw')
    image2 = repo.create_image(title: 'Title of Image2', width: 1920, height: 1080, source: 'Getty', format: 'raw')
    image3 = repo.create_image(title: 'Title of Image3', width: 1921, height: 1080, source: 'Getty', format: 'raw')

    assert_price_equal 10, get_product_price(image1[:id])
    assert_price_equal 10, get_product_price(image2[:id])
    assert_price_equal 10, get_product_price(image3[:id])
  end

  test 'price of another image' do
    image = repo.create_image(title: 'Title of Image', width: 800, height: 600, source: 'unknown', format: 'jpg')
    assert_price_equal 7, get_product_price(image[:id])
  end

  test 'price of 4k videos' do
    Timecop.travel Time.new(2022, 1, 1) + 6.hours
    video = repo.create_video(title: 'Title of Video', duration: 150, quality: '4k')
    assert_price_equal 12, get_product_price(video[:id])
  end

  test 'price of FullHD videos is 3 per started minute' do
    Timecop.travel Time.new(2022, 1, 1) + 6.hours
    video60 = repo.create_video(title: 'Title of Video', duration: 59, quality: 'FullHD')
    assert_price_equal 3, get_product_price(video60[:id])
    video61 = repo.create_video(title: 'Title of Video', duration: 60, quality: 'FullHD')
    assert_price_equal 6, get_product_price(video61[:id])
  end

  test 'price of SD videos is 1 per started minute' do
    Timecop.travel Time.new(2022, 1, 1) + 6.hours
    video60 = repo.create_video(title: 'Title of Video', duration: 59, quality: 'SD')
    assert_price_equal 1, get_product_price(video60[:id])
    video61 = repo.create_video(title: 'Title of Video', duration: 60, quality: 'SD')
    assert_price_equal 2, get_product_price(video61[:id])
  end

  test 'price of SD videos longer than 10 minutes is fixed at 10' do
    Timecop.travel Time.new(2022, 1, 1) + 6.hours
    video = repo.create_video(title: 'Title of Video', duration: 10*60, quality: 'SD')
    assert_price_equal 10, get_product_price(video[:id])
  end

  test 'the price of a video is reduced during the night' do
    video = repo.create_video(title: 'Title of Video', duration: 150, quality: '4k')
    Timecop.travel Time.new(2022, 1, 1) + 5.hours - 1.minute
    assert_price_equal 7.2, get_product_price(video[:id])
    Timecop.travel Time.new(2022, 1, 1) + 5.hours + 1.minute
    assert_price_equal 12, get_product_price(video[:id])
    Timecop.travel Time.new(2022, 1, 1) + 22.hours - 1.minute
    assert_price_equal 12, get_product_price(video[:id])
    Timecop.travel Time.new(2022, 1, 1) + 22.hours + 1.minute
    assert_price_equal 7.2, get_product_price(video[:id])
  end

  private

  def get_product_price(id)
    get product_price_url(id)
    response.parsed_body.to_f
  end

  def assert_price_equal(expected, actual)
    assert_in_delta expected, actual, 0.01
  end
end
