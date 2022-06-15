require "test_helper_training"

class Iteration1Test < TestHelperTraining
  teardown do
    Timecop.return
  end

  test 'book price is +25% from purchase' do
    begin
      ENV['BOOK_PURCHASE_PRICE'] = '10'
      book = create_book(title: 'Team of Teams', content: 'content')
      assert_price_equal 12.5, get_product_price(book.id)
    ensure
      ENV.delete('BOOK_PURCHASE_PRICE')
    end
  end
  test 'premium books are 5% more expensive' do
    begin
      ENV['BOOK_PURCHASE_PRICE'] = '10'
      book = create_book(title: 'Premium: Good Strategy Bad Strategy', content: 'content')
      assert_price_equal 13.125, get_product_price(book.id)
    ensure
      ENV.delete('BOOK_PURCHASE_PRICE')
    end
  end

  test 'image price is 7' do
    image = create_image(title: 'Image 1', content: 'content')
    assert_price_equal 7, get_product_price(image.id)
  end
  test 'premium images are 5% more expensive' do
    image = create_image(title: 'Premium image 1', content: 'content')
    assert_price_equal 7.35, get_product_price(image.id)
  end

  test 'video day price is 15' do
    Timecop.travel(Time.now.change(hour: 10))
    video = create_video(title: 'Make Data Structures', content: 'content')
    assert_price_equal 15, get_product_price(video.id)
  end
  test 'video night price is 9' do
    Timecop.travel(Time.now.change(hour: 2))
    video = create_video(title: 'From Rails to Elm and Haskell', content: 'content')
    assert_price_equal 9, get_product_price(video.id)
  end
  test 'premium video are 5% more expensive during the day' do
    Timecop.travel(Time.now.change(hour: 10))
    video = create_video(title: 'Types, and Why You Should Care PREMIUM', content: 'content')
    assert_price_equal 15.75, get_product_price(video.id)
  end
  test 'premium video are 5% more expensive during the night' do
    Timecop.travel(Time.now.change(hour: 2))
    video = create_video(title: 'DDD Sous Pression, premium', content: 'content')
    assert_price_equal 9.45, get_product_price(video.id)
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
