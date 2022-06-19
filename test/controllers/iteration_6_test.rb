require "test_helper_training"

class Iteration6Test < TestHelperTraining
  test 'users can purchase products' do
    skip 'unskip at iteration 6'
    alice = create_user(first_name: 'Alice')
    bob = create_user(first_name: 'Bob')

    book_1 = create_book(title: 'Remote', isbn: '0804137501', purchase_price: 42, is_hot: false)
    book_2 = create_book(title: 'Rework', isbn: '0307463745', purchase_price: 42, is_hot: false)
    book_3 = create_book(title: "It Doesn't Have to Be Crazy at Work", isbn: '0062874780', purchase_price: 42, is_hot: false)

    post purchases_url, params: { user_id: alice.id, product_id: book_1.id }
    assert_equal 200, response.status, response.body
    post purchases_url, params: { user_id: alice.id, product_id: book_2.id }
    assert_equal 200, response.status, response.body
    post purchases_url, params: { user_id: bob.id, product_id: book_3.id }
    assert_equal 200, response.status, response.body

    get purchases_url, params: { user_id: alice.id }

    purchased_books = response.parsed_body
    assert_equal 2, purchased_books.size
    assert_equal 'Remote', purchased_books[0]['title']
    assert_equal 'Rework', purchased_books[1]['title']
  end

  test 'creates a download when purchasing a product' do
    skip 'unskip at iteration 6'
    user = create_user(first_name: 'Alice')
    book = create_book(title: 'Team Topologies', isbn: '9781942788829', purchase_price: 42, is_hot: false)

    # No downloads before purchase
    get downloads_url, params: { user_id: user.id }
    downloaded_books = response.parsed_body['books']
    assert_nil downloaded_books

    post purchases_url, params: { user_id: user.id, product_id: book.id }
    assert_equal 200, response.status, response.body

    # One download after purchase
    get downloads_url, params: { user_id: user.id }
    downloaded_books = response.parsed_body['books'] || []
    assert_equal 1, downloaded_books.count
    assert_equal 'Team Topologies', downloaded_books[0]['title']
  end

  test 'purchases contain a price and reference to the product purchased' do
    skip 'unskip at iteration 6'
    user = create_user(first_name: 'Alice')
    book = create_book(title: 'Extreme Ownership', isbn: '9783962670658', purchase_price: 12, is_hot: false)

    post purchases_url, params: { user_id: user.id, product_id: book.id }
    assert_equal 200, response.status, response.body

    get purchases_url, params: { user_id: user.id }
    purchased_book = response.parsed_body[0]
    assert_equal 'Extreme Ownership', purchased_book['title']
    assert_equal book.id, purchased_book['item_id']
    assert_equal 15, purchased_book['price']
  end

  test 'the title and price in the invoice does not change' do
    skip 'unskip at iteration 6'
    user = create_user(first_name: 'Alice')
    book = create_book(title: 'Drive', isbn: '9781101524275', purchase_price: 42, is_hot: false)

    post purchases_url, params: { user_id: user.id, product_id: book.id }
    assert_equal 200, response.status, response.body
    update_book(item: book, title: 'Drive: The surprising truth about what motivates us', purchase_price: 24)

    get purchases_url, params: { user_id: user.id }
    purchased_book = response.parsed_body[0]
    assert_equal 'Drive', purchased_book['title']
    assert_equal 52.5, purchased_book['price']
  end

  private

  def create_user(first_name:)
    User.create!(first_name: first_name)
  end

  def update_book(item:, title: nil, purchase_price: nil)
    item.title = title unless title.nil?
    item.save!
  end
end
