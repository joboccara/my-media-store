require 'test_helper'

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  repo = ProductRepository.new

  test 'users can purchase products' do
    alice = User.create(first_name: 'Alice')
    bob = User.create(first_name: 'Bob')

    alice_book_1 = repo.create_book(title: 'Book 1', isbn: '1', purchase_price: 42, is_hot: false)
    alice_book_2 = repo.create_book(title: 'Book 2', isbn: '2', purchase_price: 42, is_hot: false)
    bob_book = repo.create_book(title: 'Book 3', isbn: '3', purchase_price: 42, is_hot: false)

    post purchases_url, params: { user_id: alice.id, product_id: alice_book_1[:id] }
    post purchases_url, params: { user_id: alice.id, product_id: alice_book_2[:id] }
    post purchases_url, params: { user_id: bob.id, product_id: bob_book[:id] }

    get purchases_url, params: { user_id: alice.id, format: :json }

    purchased_books = response.parsed_body
    assert_equal 2, purchased_books.size
    assert_equal 'Book 1', purchased_books[0]['title']
    assert_equal 'Book 2', purchased_books[1]['title']
  end

  test 'creates a download when purchasing a product' do
    user = User.create(first_name: 'Alice')
    book = repo.create_book(title: 'Title of book', isbn: '1', purchase_price: 42, is_hot: false)

    # No downloads before purchase
    get downloads_url, params: { user_id: user.id }
    downloaded_books = response.parsed_body['books']
    assert_nil downloaded_books

    post purchases_url, params: { user_id: user.id, product_id: book[:id] }

    # One download after purchase
    get downloads_url, params: { user_id: user.id }
    downloaded_books = response.parsed_body['books']
    assert_equal 1, downloaded_books.count
    assert_equal 'Title of book', downloaded_books[0]['title']
  end

  test 'purchases contain a reference to the product purchased' do
    user = User.create(first_name: 'Alice')
    book = repo.create_book(title: 'Title of book', isbn: '1', purchase_price: 42, is_hot: false)

    post purchases_url, params: { user_id: user.id, product_id: book[:id] }

    get purchases_url, params: { user_id: user.id, format: :json }
    purchased_book = response.parsed_body[0]
    assert_equal 'Title of book', purchased_book['title']
    assert_equal book[:id], purchased_book['item_id']
  end

  test 'the title in the invoice does not change' do
    user = User.create(first_name: 'Alice')
    repo = ProductRepository.new
    book = repo.create_book(title: 'Book', isbn: '1', purchase_price: 42, is_hot: false)

    post purchases_url, params: { user_id: user.id, product_id: book[:id] }

    repo.update_book(item_id: book[:id], title: 'New book')

    get purchases_url, params: { user_id: user.id, format: :json }

    purchased_books = response.parsed_body
    assert_equal 1, purchased_books.size
    assert_equal 'Book', purchased_books[0]['title']
  end
end