require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'get an item' do
    item = Item.create(kind: 'book', title: 'Item 1', content: 'Super item', category: 'star-wars')

    get product_url(item.id)

    res = response.parsed_body
    assert_equal 'Item 1', res['title']
  end
end
