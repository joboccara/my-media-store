require 'test_helper'

class ProductRepositoryTest < ActiveSupport::TestCase
  repo = ProductRepository.new

  test 'create and get book' do
    book = repo.create_book(title: 'title', content: 'content', category: 'category', page_count: 10)

    product = repo.get_product(book[:id])
    assert_equal book[:title], product[:title]

    products = repo.get_product_with_category(book[:category])
    assert_equal book[:title], products[0][:title]
  end

  test 'create and update book' do
    book = repo.create_book(title: 'title', content: 'content', category: 'category', page_count: 10)
    repo.update_book(book[:id], title: 'new title', page_count: 20)

    new_book = repo.get_product(book[:id])
    assert_equal new_book[:title], 'new title'
    assert_equal new_book[:page_count], 20
  end
end
