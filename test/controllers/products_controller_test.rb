require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'get all products' do
    book = Item.create(kind: 'book', title: 'Title of Book', content: 'Contents of Book')
    video = Item.create(kind: 'video', title: 'Title of Video', content: 'Contents of Video')

    get '/products', as: :json
    products = response.parsed_body
    assert_equal 2, products.count
    assert_equal 'book', products[0]['kind']
    assert_equal 'Title of Book', products[0]['title']
    assert_equal 'Contents of Book', products[0]['content']
    assert_equal 'video', products[1]['kind']
    assert_equal 'Title of Video', products[1]['title']
    assert_equal 'Contents of Video', products[1]['content']
  end
end
