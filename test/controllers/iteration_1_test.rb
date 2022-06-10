require "test_helper"

class Iteration1Test < ActionDispatch::IntegrationTest
  teardown do
    Timecop.return
  end

  test 'book price is +25% from purchase' do
    skip 'unskip at iteration 1'
    begin
      ENV['BOOK_PURCHASE_PRICE'] = '10'
      book = Item.create!(kind: 'book', title: 'Book 1', content: 'content')
      assert_price_equal 12.5, get_product_price(book.id)
    ensure
      ENV.delete('BOOK_PURCHASE_PRICE')
    end
  end
  test 'premium books are 5% more expensive' do
    skip 'unskip at iteration 1'
    begin
      ENV['BOOK_PURCHASE_PRICE'] = '10'
      book = Item.create!(kind: 'book', title: 'Book premium 1', content: 'content')
      assert_price_equal 13.125, get_product_price(book.id)
    ensure
      ENV.delete('BOOK_PURCHASE_PRICE')
    end
  end

  test 'image price is 7' do
    skip 'unskip at iteration 1'
    image = Item.create!(kind: 'image', title: 'Image 1', content: 'content')
    assert_price_equal 7, get_product_price(image.id)
  end
  test 'premium images are 5% more expensive' do
    skip 'unskip at iteration 1'
    image = Item.create!(kind: 'image', title: 'Premium image 1', content: 'content')
    assert_price_equal 7.35, get_product_price(image.id)
  end

  test 'video day price is 15' do
    skip 'unskip at iteration 1'
    Timecop.travel(Time.now.change(hour: 10))
    video = Item.create!(kind: 'video', title: 'Video 1', content: 'content')
    assert_price_equal 15, get_product_price(video.id)
  end
  test 'video night price is 9' do
    skip 'unskip at iteration 1'
    Timecop.travel(Time.now.change(hour: 2))
    video = Item.create!(kind: 'video', title: 'Video 1', content: 'content')
    assert_price_equal 9, get_product_price(video.id)
  end
  test 'premium video are 5% more expensive during the day' do
    skip 'unskip at iteration 1'
    Timecop.travel(Time.now.change(hour: 10))
    video = Item.create!(kind: 'video', title: 'Video 1 PREMIUM', content: 'content')
    assert_price_equal 15.75, get_product_price(video.id)
  end
  test 'premium video are 5% more expensive during the night' do
    skip 'unskip at iteration 1'
    Timecop.travel(Time.now.change(hour: 2))
    video = Item.create!(kind: 'video', title: 'Video premium 1', content: 'content')
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
