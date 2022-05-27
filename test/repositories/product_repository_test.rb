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
end
