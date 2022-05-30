require 'test_helper'

class CatalogsControllerTest < ActionDispatch::IntegrationTest
  repo = ProductRepository.new

  test 'list product from a category' do
    repo.create_book(title: 'Product 1', content: 'Super product', category: 'star-wars', page_count: 42)
    repo.create_video(title: 'Product 2', content: 'Great product', category: 'star-wars', duration: 120)
    repo.create_book(title: 'Product 3', content: 'Big product', category: 'other', page_count: 30)

    get catalog_url('star-wars')

    res = response.parsed_body
    assert_equal 2, res.count

    assert_equal 'Product 1', res[0]['title']
    assert_equal 42, res[0]['page_count']
    assert_equal 4.2, res[0]['price']

    assert_equal 'Product 2', res[1]['title']
    assert_equal 120, res[1]['duration']
    assert_equal 2, res[1]['price']
  end
end
