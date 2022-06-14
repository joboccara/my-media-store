require "test_helper"

class Iteration2Test < ActionDispatch::IntegrationTest
  test 'items should have additional details' do
    skip 'unskip at iteration 2'
    create_book(title: 'My book', isbn: '9781603095099', purchase_price: 12, is_hot: false)
    create_image(title: 'My image', width: 800, height: 600, source: 'Getty', format: 'jpg')
    create_video(title: 'My video', duration: 120, quality: 'FullHD')

    get '/products'
    products_by_kind = response.parsed_body

    book = products_by_kind['books'][0]
    assert_equal 'book', book['kind']
    assert_equal 'My book', book['title']
    assert_equal '9781603095099', book['isbn']
    assert_nil book['purchase_price']
    assert_equal false, book['is_hot']
    assert_nil book['created_at']

    image = products_by_kind['images'][0]
    assert_equal 'image', image['kind']
    assert_equal 'My image', image['title']
    assert_equal 800, image['width']
    assert_equal 600, image['height']
    assert_equal 'Getty', image['source']
    assert_equal 'jpg', image['format']
    assert_nil image['created_at']

    video = products_by_kind['videos'][0]
    assert_equal 'video', video['kind']
    assert_equal 'My video', video['title']
    assert_equal 120, video['duration']
    assert_equal 'FullHD', video['quality']
    assert_nil video['created_at']
  end

  private

  def create_book(title:, isbn:, purchase_price:, is_hot:)
    Item.create!(kind: 'book', title: title, content: 'content')
  end

  def create_image(title:, width:, height:, source:, format:)
    Item.create!(kind: 'image', title: title, content: 'content')
  end

  def create_video(title:, duration:, quality:)
    Item.create!(kind: 'video', title: title, content: 'content')
  end
end
