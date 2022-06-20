require "test_helper_training"

class Iteration1Test < TestHelperTraining
  teardown do
    Timecop.return
  end

  test 'book price is +25% from purchase' do
    skip 'unskip at iteration 1'
    begin
      ENV['BOOK_PURCHASE_PRICE'] = '10'
      book = create_book(title: 'Team of Teams', content: 'content')
      assert_price_equal 12.5, get_product_price(book)
    ensure
      ENV.delete('BOOK_PURCHASE_PRICE')
    end
  end
  test 'premium books are 5% more expensive' do
    skip 'unskip at iteration 1'
    begin
      ENV['BOOK_PURCHASE_PRICE'] = '10'
      book = create_book(title: 'Premium: Good Strategy Bad Strategy', content: 'content')
      assert_price_equal 13.125, get_product_price(book)
    ensure
      ENV.delete('BOOK_PURCHASE_PRICE')
    end
  end

  test 'image price is 7' do
    skip 'unskip at iteration 1'
    image = create_image(title: 'Image 1', content: 'content')
    assert_price_equal 7, get_product_price(image)
  end
  test 'premium images are not more expensive' do
    skip 'unskip at iteration 1'
    image = create_image(title: 'Premium image 1', content: 'content')
    assert_price_equal 7, get_product_price(image)
  end

  test 'video day price is 15' do
    skip 'unskip at iteration 1'
    Timecop.travel(Time.now.change(hour: 10))
    video = create_video(title: 'Make Data Structures', content: 'content')
    assert_price_equal 15, get_product_price(video)
  end
  test 'video night price is 9' do
    skip 'unskip at iteration 1'
    Timecop.travel(Time.now.change(hour: 2))
    video = create_video(title: 'From Rails to Elm and Haskell', content: 'content')
    assert_price_equal 9, get_product_price(video)
  end
  test 'premium videos are 5% more expensive during the day' do
    skip 'unskip at iteration 1'
    Timecop.travel(Time.now.change(hour: 10))
    video = create_video(title: 'Types, and Why You Should Care PREMIUM', content: 'content')
    assert_price_equal 15.75, get_product_price(video)
  end
  test 'premium videos are 5% more expensive during the night' do
    skip 'unskip at iteration 1'
    Timecop.travel(Time.now.change(hour: 2))
    video = create_video(title: 'DDD Sous Pression, premium', content: 'content')
    assert_price_equal 9.45, get_product_price(video)
  end
end
