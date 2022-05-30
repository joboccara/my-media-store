require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  repo = ProductRepository.new

  test 'gets a book with its details' do
    book = repo.create_book(title: 'Item 1', content: 'Super item', category: 'default', page_count: 42)

    get product_url(book.id)

    res = response.parsed_body
    assert_equal 'Item 1', res['title']
    assert_equal 'book', res['kind']
    assert_equal 42, res['page_count']
    assert_nil res['width']
    assert_nil res['duration']
    assert_equal 4.2, res['price']
  end
  test 'gets an image with its details' do
    image = repo.create_image(title: 'Item 2', content: 'Super item', category: 'default', width: 800, height: 600)

    get product_url(image.id)

    res = response.parsed_body
    assert_equal 'Item 2', res['title']
    assert_equal 'image', res['kind']
    assert_nil res['page_count']
    assert_equal 800, res['width']
    assert_nil res['duration']
    assert_equal 1.4, res['price']
  end
  test 'gets a video with its details' do
    video = repo.create_video(title: 'Item 3', content: 'Super item', category: 'default', duration: 120)

    get product_url(video.id)

    res = response.parsed_body
    assert_equal 'Item 3', res['title']
    assert_equal 'video', res['kind']
    assert_nil res['page_count']
    assert_nil res['width']
    assert_equal 120, res['duration']
    assert_equal 2, res['price']
  end
end
