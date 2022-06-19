require "test_helper_training"

class ProductsControllerTest < TestHelperTraining
  test 'get all products' do
    create_book(title: 'Domain-Driven Design', content: 'Contents of Book1', isbn: '9780132181273', purchase_price: 1, is_hot: false)
    create_book(title: 'Turn the Ship Around', content: 'Contents of Book2', isbn: '9781101623695', purchase_price: 2, is_hot: false)
    create_video(title: 'Title of Video', content: 'Contents of Video', duration: 60, quality: 'SD')

    get '/products'
    products_by_kind = response.parsed_body

    books = products_by_kind['books']
    assert_equal 2, books.count
    assert_equal 'book', books[0]['kind']
    assert_equal 'Domain-Driven Design', books[0]['title']
    assert_equal 'Contents of Book1', books[0]['content']
    assert_equal 'book', books[1]['kind']
    assert_equal 'Turn the Ship Around', books[1]['title']
    assert_equal 'Contents of Book2', books[1]['content']

    videos = products_by_kind['videos']
    assert_equal 'video', videos[0]['kind']
    assert_equal 'Title of Video', videos[0]['title']
    assert_equal 'Contents of Video', videos[0]['content']
  end

  test 'get the products of a month' do
    book = create_book(title: 'The Lean Startup', content: 'Contents of Book', isbn: '0670921602', purchase_price: 1, is_hot: false)
    Item.update(book[:id], created_at: '2019-01-01')
    video = create_video(title: 'Title of Video', content: 'Contents of Video', duration: 60, quality: 'SD')
    Item.update(video[:id], created_at: '2019-02-01')

    get '/products?month=february'
    products_by_kind = response.parsed_body

    assert_equal ['videos'], products_by_kind.keys
    videos = products_by_kind['videos']
    assert_equal 'video', videos[0]['kind']
    assert_equal 'Title of Video', videos[0]['title']
    assert_equal 'Contents of Video', videos[0]['content']
  end
end
