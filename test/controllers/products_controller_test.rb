require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'gets an item with its details' do
    item = Item.create!(kind: 'book', title: 'Item 1', content: 'Super item')
    book_details = BookDetail.create!(page_count: 42, item: item)

    get product_url(item.id, params: {format: :json })

    res = response.parsed_body
    assert_equal 'Item 1', res['title']
    assert_equal 'book', res['kind']
    assert_equal 42, res['page_count']
  end
end
