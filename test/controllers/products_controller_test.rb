require "test_helper_training"

class ProductsControllerTest < TestHelperTraining
  test 'get all products' do
    create_book(title: 'Domain-Driven Design', content: 'Contents of Book1')
    create_book(title: 'Turn the Ship Around', content: 'Contents of Book2')
    create_video(title: 'Tout ce que vous avez toujours voulus savoir sur la programmation fonctionnelle', content: 'Contents of Video')

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
    assert_equal 'Tout ce que vous avez toujours voulus savoir sur la programmation fonctionnelle', videos[0]['title']
    assert_equal 'Contents of Video', videos[0]['content']
  end

  test 'get the products of a month' do
    create_book(title: 'The Lean Startup', content: 'Contents of Book', created_at: '2019-01-01')
    create_video(title: 'TDD as in Type-Driven Development', content: 'Contents of Video', created_at: '2019-02-01')

    get '/products?month=february'
    products_by_kind = response.parsed_body

    assert_equal ['videos'], products_by_kind.keys
    videos = products_by_kind['videos']
    assert_equal 'video', videos[0]['kind']
    assert_equal 'TDD as in Type-Driven Development', videos[0]['title']
    assert_equal 'Contents of Video', videos[0]['content']
  end
end
