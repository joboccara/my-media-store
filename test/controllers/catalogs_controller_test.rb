require 'test_helper'

class CatalogsControllerTest < ActionDispatch::IntegrationTest
  test 'list items from a category' do
    Item.create(kind: 'book', title: 'Item 1', content: 'Super item', category: 'star-wars')
    Item.create(kind: 'video', title: 'Item 2', content: 'Great item', category: 'star-wars')
    Item.create(kind: 'book', title: 'Item 3', content: 'Great item', category: 'other')

    get catalog_url('star-wars')

    res = response.parsed_body
    assert_equal 2, res.count
    assert_equal 'Item 1', res[0]['title']
  end
end
