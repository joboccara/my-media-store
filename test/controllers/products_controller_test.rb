require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'gets a book with its details' do
    item = Item.create!(kind: 'book', title: 'Item 1', content: 'Super item')
    BookDetail.create!(page_count: 42, item: item)

    get product_url(item.id, params: {format: :json })

    res = response.parsed_body
    assert_equal 'Item 1', res['title']
    assert_equal 'book', res['kind']
    assert_equal 42, res['page_count']
    assert_nil res['width']
    assert_nil res['duration']
  end
  test 'gets an image with its details' do
    item = Item.create!(kind: 'image', title: 'Item 2', content: 'Super item')
    ImageDetail.create!(width: 800, height: 600, item: item)

    get product_url(item.id, params: {format: :json })

    res = response.parsed_body
    assert_equal 'Item 2', res['title']
    assert_equal 'image', res['kind']
    assert_nil res['page_count']
    assert_equal 800, res['width']
    assert_nil res['duration']
  end
  test 'gets a video with its details' do
    item = Item.create!(kind: 'video', title: 'Item 3', content: 'Super item')
    VideoDetail.create!(duration: 120, item: item)

    get product_url(item.id, params: {format: :json })

    res = response.parsed_body
    assert_equal 'Item 3', res['title']
    assert_equal 'video', res['kind']
    assert_nil res['page_count']
    assert_nil res['width']
    assert_equal 120, res['duration']
  end
end