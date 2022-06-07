require 'test_helper'

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  test 'products can be purchased' do
    alice = User.create(first_name: 'Alice')
    bob = User.create(first_name: 'Bob')

    repo = ProductRepository.new
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

  test 'the title in the invoice does not change' do
    alice = User.create(first_name: 'Alice')
    repo = ProductRepository.new
    alice_book = repo.create_book(title: 'Book 1', isbn: '1', purchase_price: 42, is_hot: false)

    post purchases_url, params: { user_id: alice.id, product_id: alice_book[:id] }

    repo.update_book(item_id: alice_book[:id], title: 'New book 1')

    get purchases_url, params: { user_id: alice.id, format: :json }

    purchased_books = response.parsed_body
    assert_equal 1, purchased_books.size
    assert_equal 'Book 1', purchased_books[0]['title']
  end
end