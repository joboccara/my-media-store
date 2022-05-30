require 'test_helper'

class CatalogsControllerTest < ActionDispatch::IntegrationTest
  repo = ProductRepository.new

  test 'list items from a category' do
    repo.create_book(title: 'Item 1', content: 'Super item', category: 'star-wars', page_count: 42)
    repo.create_video(title: 'Item 2', content: 'Great item', category: 'star-wars', duration: 120)
    repo.create_book(title: 'Item 3', content: 'Big item', category: 'other', page_count: 30)

    get catalog_url('star-wars')

    res = response.parsed_body
    assert_equal 2, res.count

    assert_equal 'Item 1', res[0]['title']
    assert_equal 42, res[0]['page_count']
    assert_equal 4.2, res[0]['price']

    assert_equal 'Item 2', res[1]['title']
    assert_equal 120, res[1]['duration']
    assert_equal 2, res[1]['price']
  end
end
