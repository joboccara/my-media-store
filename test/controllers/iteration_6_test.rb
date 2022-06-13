require "test_helper"

class Iteration6Test < ActionDispatch::IntegrationTest
  # https://github.com/joboccara/my-media-store/blob/jonathan-attempt02/test/controllers/purchases_controller_test.rb
  test 'users can purchase products' do
    skip 'unskip at iteration 6'
    alice = create_user(first_name: 'Alice')
    bob = create_user(first_name: 'Bob')

    alice_book_1 = create_book(title: 'Book 1', isbn: '1', purchase_price: 42, is_hot: false)
    alice_book_2 = create_book(title: 'Book 2', isbn: '2', purchase_price: 42, is_hot: false)
    bob_book = create_book(title: 'Book 3', isbn: '3', purchase_price: 42, is_hot: false)

    post purchases_url, params: { user_id: alice.id, product_id: alice_book_1.id }
    post purchases_url, params: { user_id: alice.id, product_id: alice_book_2.id }
    post purchases_url, params: { user_id: bob.id, product_id: bob_book.id }

    get purchases_url, params: { user_id: alice.id }

    purchased_books = response.parsed_body
    assert_equal 2, purchased_books.size
    assert_equal 'Book 1', purchased_books[0]['title']
    assert_equal 'Book 2', purchased_books[1]['title']
  end

  test 'creates a download when purchasing a product' do
    skip 'unskip at iteration 6'
    user = create_user(first_name: 'Alice')
    book = create_book(title: 'Title of book', isbn: '1', purchase_price: 42, is_hot: false)

    # No downloads before purchase
    get downloads_url, params: { user_id: user.id }
    downloaded_books = response.parsed_body['books']
    assert_nil downloaded_books

    post purchases_url, params: { user_id: user.id, product_id: book[:id] }

    # One download after purchase
    get downloads_url, params: { user_id: user.id }
    downloaded_books = response.parsed_body['books'] || []
    assert_equal 1, downloaded_books.count
    assert_equal 'Title of book', downloaded_books[0]['title']
  end

  test 'purchases contain a price and reference to the product purchased' do
    skip 'unskip at iteration 6'
    user = create_user(first_name: 'Alice')
    book = create_book(title: 'Title of book', isbn: '1', purchase_price: 12, is_hot: false)

    post purchases_url, params: { user_id: user.id, product_id: book[:id] }

    get purchases_url, params: { user_id: user.id }
    purchased_book = response.parsed_body[0]
    assert_equal 'Title of book', purchased_book['title']
    assert_equal book[:id], purchased_book['item_id']
    assert_equal 15, purchased_book['price']
  end

  test 'the title in the invoice does not change' do
    skip 'unskip at iteration 6'
    user = create_user(first_name: 'Alice')
    book = create_book(title: 'Book', isbn: '1', purchase_price: 42, is_hot: false)

    post purchases_url, params: { user_id: user.id, product_id: book[:id] }

    update_book(item_id: book[:id], title: 'New book')

    get purchases_url, params: { user_id: user.id }

    purchased_book = response.parsed_body[0]
    assert_equal 'Book', purchased_book['title']
  end

  test 'the price in the invoice does not change' do
    skip 'unskip at iteration 6'
    user = create_user(first_name: 'Alice')
    book = create_book(title: 'Book', isbn: '1', purchase_price: 12, is_hot: false)

    post purchases_url, params: { user_id: user.id, product_id: book[:id] }

    update_book(item_id: book[:id], purchase_price: 24)

    get purchases_url, params: { user_id: user.id, format: :json }

    purchased_book = response.parsed_body[0]
    assert_equal 15, purchased_book['price']
  end

  private

  def create_user(first_name:)
    User.create!(first_name: first_name)
  end

  def create_book(title:, isbn:, purchase_price:, is_hot:)
    Item.create!(kind: 'book', title: title, content: 'content')
  end

  def update_book(item_id:, title: nil, purchase_price: nil)

  end
end
