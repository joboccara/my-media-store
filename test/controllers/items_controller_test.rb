require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "shows all items with their price" do
    user = User.create!(first_name: 'Bob')
    book_1 = Item.create!(kind: 'book', title: 'Title of Book1', content: 'Contents of Book1')
    book_2 = Item.create!(kind: 'book', title: 'Title of Book2', content: 'Contents of Book2')

    get items_url, params: { format: :json }

    books_in_catalog = response.parsed_body['books']
    assert_equal 2, books_in_catalog.count
    assert_equal 'Title of Book1', books_in_catalog[0]['title']
    assert_equal 'Contents of Book1', books_in_catalog[0]['content']
    assert_equal 15, books_in_catalog[0]['price']
    assert_equal 'Title of Book2', books_in_catalog[1]['title']
    assert_equal 'Contents of Book2', books_in_catalog[1]['content']
    assert_equal 15, books_in_catalog[1]['price']
  end
end
