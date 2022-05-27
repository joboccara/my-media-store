require 'test_helper'

class CatalogsControllerTest < ActionDispatch::IntegrationTest
  test 'list items from a category' do
    item1 = Item.create(kind: 'book', title: 'Item 1', content: 'Super item', category: 'star-wars')
    BookDetail.create!(page_count: 42, item: item1)
    item2 = Item.create(kind: 'video', title: 'Item 2', content: 'Great item', category: 'star-wars')
    VideoDetail.create!(duration: 120, item: item2)
    item3 = Item.create(kind: 'book', title: 'Item 3', content: 'Great item', category: 'other')
    BookDetail.create!(page_count: 30, item: item3)

    get catalog_url('star-wars')

    res = response.parsed_body
    assert_equal 2, res.count
    assert_equal 'Item 1', res[0]['title']
    assert_equal 42, res[0]['page_count']
    assert_equal 'Item 2', res[1]['title']
    assert_equal 120, res[1]['duration']
  end
end
