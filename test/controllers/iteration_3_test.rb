require "test_helper_training"
require "csv"

class Iteration3Test < TestHelperTraining
  teardown do
    Timecop.return
  end

  test 'prices books at +25% margin' do
    skip 'unskip at iteration 3'
    book1 = create_book(title: 'Practical Object‑Oriented Design in Ruby', isbn: '9780132930871', purchase_price: 12, is_hot: false)
    assert_price_equal 15, get_product_price(book1.id)

    book2 = create_book(title: 'Clean Architecture', isbn: '9780134494326', purchase_price: 16, is_hot: false)
    assert_price_equal 20, get_product_price(book2.id)
  end

  test 'prices hot books at 9.99 during weekdays' do
    skip 'unskip at iteration 3'
    book = create_book(title: 'The Software Craftsman', isbn: '0134052501', purchase_price: 16, is_hot: true)
    Timecop.travel(Time.new(2022, 1, 3)) # Monday
    assert_price_equal 9.99, get_product_price(book.id)
    Timecop.travel(Time.new(2022, 1, 4)) # Tuesday
    assert_price_equal 9.99, get_product_price(book.id)
    Timecop.travel(Time.new(2022, 1, 5)) # Wednesday
    assert_price_equal 9.99, get_product_price(book.id)
    Timecop.travel(Time.new(2022, 1, 6)) # Thursday
    assert_price_equal 9.99, get_product_price(book.id)
    Timecop.travel(Time.new(2022, 1, 7)) # Friday
    assert_price_equal 9.99, get_product_price(book.id)
    Timecop.travel(Time.new(2022, 1, 8)) # Saturday
    assert_price_equal 20, get_product_price(book.id)
    Timecop.travel(Time.new(2022, 1, 9)) # Sunday
    assert_price_equal 20, get_product_price(book.id)
  end

  test 'checks the ISBN list to price books' do
    skip 'unskip at iteration 3'
    begin
      CSV.open(Rails.root.join('app/assets/config/isbn_prices.csv'), 'wb') do |csv|
        csv << ['ISBN', 'price']
        csv << ['1449373321', '14.99']
        csv << ['0131177052', '19.99']
        csv << ['1736049119', '23.99']
      end

      book = create_book(title: 'Working Effectively with Legacy Code', isbn: '0131177052', purchase_price: 12, is_hot: false)
      assert_price_equal 19.99, get_product_price(book.id)

      book = create_book(title: 'Premium Working Effectively with Legacy Code', isbn: '0131177052', purchase_price: 12, is_hot: false)
      assert_price_equal 20.99, get_product_price(book.id)

      book = create_book(title: 'Working Effectively with Legacy Code', isbn: '0131177052', purchase_price: 12, is_hot: true)
      Timecop.travel(Time.new(2022, 1, 3)) # Monday
      assert_price_equal 19.99, get_product_price(book.id)
    ensure
      File.delete(Rails.root.join('app/assets/config/isbn_prices.csv'))
    end
  end

  test 'prices images from NationalGeographic .02/9600px' do
    skip 'unskip at iteration 3'
    image = create_image(title: 'Title of Image', width: 800, height: 600, source: 'NationalGeographic', format: 'jpg')
    assert_price_equal 1, get_product_price(image.id)
  end

  test 'prices images from Getty at 1 when below 1280x720' do
    skip 'unskip at iteration 3'
    image = create_image(title: 'Title of Image', width: 1280, height: 720, source: 'Getty', format: 'jpg')
    assert_price_equal 1, get_product_price(image.id)
  end

  test 'prices images from Getty at 3 when below 1920x1080' do
    skip 'unskip at iteration 3'
    image1 = create_image(title: 'Title of Image1', width: 1281, height: 720, source: 'Getty', format: 'jpg')
    assert_price_equal 3, get_product_price(image1.id)

    image2 = create_image(title: 'Title of Image2', width: 1920, height: 1080, source: 'Getty', format: 'jpg')
    assert_price_equal 3, get_product_price(image2.id)
  end

  test 'prices images from Getty at 5 when above 1920x1080' do
    skip 'unskip at iteration 3'
    image = create_image(title: 'Title of Image', width: 1921, height: 1080, source: 'Getty', format: 'jpg')
    assert_price_equal 5, get_product_price(image.id)
  end

  test 'prices images from Getty in raw format at 10' do
    skip 'unskip at iteration 3'
    image1 = create_image(title: 'Title of Image1', width: 800, height: 600, source: 'Getty', format: 'raw')
    image2 = create_image(title: 'Title of Image2', width: 1920, height: 1080, source: 'Getty', format: 'raw')
    image3 = create_image(title: 'Title of Image3', width: 1921, height: 1080, source: 'Getty', format: 'raw')

    assert_price_equal 10, get_product_price(image1.id)
    assert_price_equal 10, get_product_price(image2.id)
    assert_price_equal 10, get_product_price(image3.id)
  end

  test 'prices other images at 7' do
    skip 'unskip at iteration 3'
    image = create_image(title: 'Title of Image', width: 800, height: 600, source: 'unknown', format: 'jpg')
    assert_price_equal 7, get_product_price(image.id)
  end

  test 'prices 4k videos at 0.08/second' do
    skip 'unskip at iteration 3'
    Timecop.travel Time.new(2022, 1, 1) + 6.hours
    video = create_video(title: 'Title of Video', duration: 150, quality: '4k')
    assert_price_equal 12, get_product_price(video.id)
  end

  test 'prices FullHD videos at 3 per started minute' do
    skip 'unskip at iteration 3'
    Timecop.travel Time.new(2022, 1, 1) + 6.hours
    video60 = create_video(title: 'Title of Video', duration: 59, quality: 'FullHD')
    assert_price_equal 3, get_product_price(video60.id)
    video61 = create_video(title: 'Title of Video', duration: 60, quality: 'FullHD')
    assert_price_equal 6, get_product_price(video61.id)
  end

  test 'prices SD videos at 1 per started minute' do
    skip 'unskip at iteration 3'
    Timecop.travel Time.new(2022, 1, 1) + 6.hours
    video60 = create_video(title: 'Title of Video', duration: 59, quality: 'SD')
    assert_price_equal 1, get_product_price(video60.id)
    video61 = create_video(title: 'Title of Video', duration: 60, quality: 'SD')
    assert_price_equal 2, get_product_price(video61.id)
  end

  test 'prices SD videos longer than 10 minutes at 10' do
    skip 'unskip at iteration 3'
    Timecop.travel Time.new(2022, 1, 1) + 6.hours
    video = create_video(title: 'Title of Video', duration: 12 * 60, quality: 'SD')
    assert_price_equal 10, get_product_price(video.id)
  end

  test 'reduces video prices by -40% during the night' do
    skip 'unskip at iteration 3'
    video = create_video(title: 'Title of Video', duration: 150, quality: '4k')
    Timecop.travel Time.new(2022, 1, 1) + 5.hours - 1.minute
    assert_price_equal 7.2, get_product_price(video.id)
    Timecop.travel Time.new(2022, 1, 1) + 5.hours + 1.minute
    assert_price_equal 12, get_product_price(video.id)
    Timecop.travel Time.new(2022, 1, 1) + 22.hours - 1.minute
    assert_price_equal 12, get_product_price(video.id)
    Timecop.travel Time.new(2022, 1, 1) + 22.hours + 1.minute
    assert_price_equal 7.2, get_product_price(video.id)
  end

  test 'bumps price of any product by +5% if the title contains "premium"' do
    skip 'unskip at iteration 3'
    book1 = create_book(title: 'Accelerate', isbn: '9781942788355', purchase_price: 12, is_hot: false)
    assert_price_equal 15, get_product_price(book1.id)
    book = create_book(title: 'The Mythical Man-Month premium', isbn: '9780132119160', purchase_price: 12, is_hot: false)
    assert_price_equal 15.75, get_product_price(book.id)

    image = create_image(title: 'Title of Image', width: 800, height: 600, source: 'unknown', format: 'jpg')
    assert_price_equal 7, get_product_price(image.id)

    image = create_image(title: 'Premium title of Image', width: 800, height: 600, source: 'unknown', format: 'jpg')
    assert_price_equal 7.35, get_product_price(image.id)

    Timecop.travel Time.new(2022, 1, 1) + 22.hours - 1.minute
    video = create_video(title: 'Title of Video', duration: 150, quality: '4k')
    assert_price_equal 12, get_product_price(video.id)
    video = create_video(title: 'Title of Video premium', duration: 150, quality: '4k')
    assert_price_equal 12.6, get_product_price(video.id)
  end

  private

  def get_product_price(id)
    get product_price_url(id)
    assert_equal 200, response.status, response.body
    response.parsed_body.to_f
  end

  def assert_price_equal(expected, actual)
    assert_in_delta expected, actual, 0.01
  end
end
