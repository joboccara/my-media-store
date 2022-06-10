require "test_helper_training"

class Iteration1Test < TestHelperTraining
  teardown do
    Timecop.return
  end

  test 'book price is +25% from purchase' do
    book = create_book(title: 'Team of Teams', isbn: '1591847486', purchase_price: 10, is_hot: false)
    assert_price_equal 12.5, get_product_price(book[:id])
  end
  test 'premium books are 5% more expensive' do
    book = create_book(title: 'Premium: Good Strategy Bad Strategy', isbn: '9780307886231', purchase_price: 10, is_hot: false)
    assert_price_equal 13.125, get_product_price(book[:id])
  end

  test 'image price is 7' do
    image = create_image(title: 'Image 1', width: 800, height: 600, source: 'unknown', format: 'jpg')
    assert_price_equal 7, get_product_price(image[:id])
  end
  test 'premium images are 5% more expensive' do
    image = create_image(title: 'Premium image 1', width: 800, height: 600, source: 'unknown', format: 'jpg')
    assert_price_equal 7.35, get_product_price(image[:id])
  end

  test 'video day price' do
    Timecop.travel(Time.now.change(hour: 10))
    video = create_video(title: 'Make Data Structures', duration: 150, quality: '4k')
    assert_price_equal 12, get_product_price(video[:id])
  end
  test 'video night price is 9' do
    Timecop.travel(Time.now.change(hour: 2))
    video = create_video(title: 'From Rails to Elm and Haskell', duration: 150, quality: '4k')
    assert_price_equal 7.2, get_product_price(video[:id])
  end
  test 'premium video are 5% more expensive during the day' do
    Timecop.travel(Time.now.change(hour: 10))
    video = create_video(title: 'Types, and Why You Should Care PREMIUM', duration: 150, quality: '4k')
    assert_price_equal 12.6, get_product_price(video[:id])
  end
  test 'premium video are 5% more expensive during the night' do
    Timecop.travel(Time.now.change(hour: 2))
    video = create_video(title: 'DDD Sous Pression, premium', duration: 150, quality: '4k')
    assert_price_equal 7.56, get_product_price(video[:id])
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
