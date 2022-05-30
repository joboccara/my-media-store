require 'test_helper'

class ProductRepositoryTest < ActiveSupport::TestCase
  repo = ProductRepository.new

  test 'create and get book' do
    book = repo.create_book(title: 'title', content: 'content', category: 'category', page_count: 10)

    product = repo.get_product(book.id)
    assert_equal book.title, product.title

    products = repo.get_product_with_category(book.category)
    assert_equal book.title, products[0].title
  end
  test 'get books of the week' do
    book1 = repo.create_book(title: 'Book 1', content: 'content', category: 'category', page_count: 10)
    book2 = repo.create_book(title: 'Book 2', content: 'content', category: 'category', page_count: 10)
    image = repo.create_image(title: 'Image', content: 'content', category: 'category', width: 10, height: 10)

    books = repo.books_of_week(Time.new)

    assert_equal 2, books.count
  end
end
