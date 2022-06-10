require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'get all products' do
    Item.create!(kind: 'book', title: 'Title of Book1', content: 'Contents of Book1')
    Item.create!(kind: 'book', title: 'Title of Book2', content: 'Contents of Book2')
    Item.create!(kind: 'video', title: 'Title of Video', content: 'Contents of Video')

    get '/products'
    products_by_kind = response.parsed_body

    books = products_by_kind['books']
    assert_equal 2, books.count
    assert_equal 'book', books[0]['kind']
    assert_equal 'Title of Book1', books[0]['title']
    assert_equal 'Contents of Book1', books[0]['content']
    assert_equal 'book', books[1]['kind']
    assert_equal 'Title of Book2', books[1]['title']
    assert_equal 'Contents of Book2', books[1]['content']

    videos = products_by_kind['videos']
    assert_equal 'video', videos[0]['kind']
    assert_equal 'Title of Video', videos[0]['title']
    assert_equal 'Contents of Video', videos[0]['content']
  end

  test 'get the products of a month' do
    Item.create!(kind: 'book', title: 'Title of Book', content: 'Contents of Book', created_at: '2019-01-01')
    Item.create!(kind: 'video', title: 'Title of Video', content: 'Contents of Video', created_at: '2019-02-01')

    get '/products?month=february'
    products_by_kind = response.parsed_body

    assert_equal ['videos'], products_by_kind.keys
    videos = products_by_kind['videos']
    assert_equal 'video', videos[0]['kind']
    assert_equal 'Title of Video', videos[0]['title']
    assert_equal 'Contents of Video', videos[0]['content']
  end
end
