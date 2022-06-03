require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  repo = ProductRepository.new

  test 'gets a book with its details' do
    book = repo.create_book(title: 'Item 1', content: 'Super item', category: 'default', page_count: 42)

    get product_url(book[:id])

    res = response.parsed_body
    assert_equal 'Item 1', res['title']
    assert_equal 'book', res['kind']
    assert_equal 42, res['page_count']
    assert_nil res['width']
    assert_nil res['duration']
  end
  test 'gets an image with its details' do
    image = repo.create_image(title: 'Item 2', content: 'Super item', category: 'default', width: 800, height: 600)

    get product_url(image[:id])

    res = response.parsed_body
    assert_equal 'Item 2', res['title']
    assert_equal 'image', res['kind']
    assert_nil res['page_count']
    assert_equal 800, res['width']
    assert_nil res['duration']
  end
  test 'gets a video with its details' do
    video = repo.create_video(title: 'Item 3', content: 'Super item', category: 'default', duration: 120)

    get product_url(video[:id])

    res = response.parsed_body
    assert_equal 'Item 3', res['title']
    assert_equal 'video', res['kind']
    assert_nil res['page_count']
    assert_nil res['width']
    assert_equal 120, res['duration']
  end

  test 'gets all products' do
    repo.create_book(title: 'Item 1', content: 'Super item', category: 'default', page_count: 42)
    repo.create_image(title: 'Item 2', content: 'Super item', category: 'default', width: 800, height: 600)
    repo.create_video(title: 'Item 3', content: 'Super item', category: 'default', duration: 120)

    get products_url

    res = response.parsed_body
    assert_equal 3, res.size
    assert_equal 'Item 1', res[0]['title']
    assert_equal 'Item 2', res[1]['title']
    assert_equal 'Item 3', res[2]['title']
  end

  test 'get the products of a month' do
    book = repo.create_book(title: 'Title of Book', content: 'Contents of Book', category: 'star-wars', page_count: 42, created_at: '2019-01-01')
    video = repo.create_video(title: 'Title of Video', content: 'Contents of Video', category: 'star-wars', duration: 60, created_at: '2019-02-01')

    get '/products?month=february', as: :json

    # products_by_kind = response.parsed_body
    # assert_equal ['videos'], products_by_kind.keys
    videos = response.parsed_body
    assert_equal 'video', videos[0]['kind']
    assert_equal 'Title of Video', videos[0]['title']
  end
end
