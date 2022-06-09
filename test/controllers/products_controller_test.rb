require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'get all products' do
    Item.create!(kind: 'book', title: 'Title of Book1', content: 'Contents of Book1')
    Item.create!(kind: 'book', title: 'Title of Book2', content: 'Contents of Book2')
    Item.create!(kind: 'video', title: 'Title of Video', content: 'Contents of Video')

    get '/products'
    products_by_kind = response.parsed_body

    books = products_by_kind['books']
    assert_equal 2, books.count
    assert_equal 'book', books[0]['kind']
    assert_equal 'Title of Book1', books[0]['title']
    assert_equal 'Contents of Book1', books[0]['content']
    assert_equal 'book', books[1]['kind']
    assert_equal 'Title of Book2', books[1]['title']
    assert_equal 'Contents of Book2', books[1]['content']

    videos = products_by_kind['videos']
    assert_equal 'video', videos[0]['kind']
    assert_equal 'Title of Video', videos[0]['title']
    assert_equal 'Contents of Video', videos[0]['content']
  end

  test 'get the products of a month' do
    Item.create!(kind: 'book', title: 'Title of Book', content: 'Contents of Book', created_at: '2019-01-01')
    Item.create!(kind: 'video', title: 'Title of Video', content: 'Contents of Video', created_at: '2019-02-01')

    get '/products?month=february'
    products_by_kind = response.parsed_body

    assert_equal ['videos'], products_by_kind.keys
    videos = products_by_kind['videos']
    assert_equal 'video', videos[0]['kind']
    assert_equal 'Title of Video', videos[0]['title']
    assert_equal 'Contents of Video', videos[0]['content']
  end

  test 'items should have additional details' do
    skip 'unskip at iteration 2'
    create_book(title: 'My book', isbn: '123', purchase_price: 12, is_hot: false)
    create_image(title: 'My image', width: 800, height: 600, source: 'Getty', format: 'jpg')
    create_video(title: 'My video', duration: 120, quality: 'FullHD')

    get '/products'
    products_by_kind = response.parsed_body

    book = products_by_kind['books'][0]
    assert_equal 'book', book['kind']
    assert_equal 'My book', book['title']
    assert_equal '123', book['isbn']
    assert_equal nil, book['purchase_price']
    assert_equal false, book['is_hot']
    assert_equal nil, book['created_at']
    image = products_by_kind['images'][0]
    assert_equal 'image', image['kind']
    assert_equal 'My image', image['title']
    assert_equal 800, image['width']
    assert_equal 600, image['height']
    assert_equal 'Getty', image['source']
    assert_equal 'jpg', image['format']
    assert_equal nil, image['created_at']
    video = products_by_kind['videos'][0]
    assert_equal 'video', video['kind']
    assert_equal 'My video', video['title']
    assert_equal 120, video['duration']
    assert_equal 'FullHD', video['quality']
    assert_equal nil, video['created_at']
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
