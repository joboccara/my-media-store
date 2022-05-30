require 'test_helper'

class ProductRepositoryTest < ActiveSupport::TestCase
  repo = ProductRepository.new

  test 'create, get and update book' do
    book = repo.create_book(title: 'title', content: 'content', category: 'category', page_count: 10)

    product = repo.get_product(book[:id])
    assert_equal 'title', product[:title]
    assert_equal 10, product[:page_count]

    products = repo.get_product_with_category(book[:category])
    assert_equal 'title', products[0][:title]
    assert_equal 10, products[0][:page_count]

    repo.update_book(item_id: book[:id], title: 'new title', page_count: 20)
    new_book = repo.get_product(book[:id])
    assert_equal new_book[:title], 'new title'
    assert_equal new_book[:page_count], 20
end

  test 'create, get and update image' do
    image = repo.create_image(title: 'title', content: 'content', category: 'category', width: 800, height: 600)

    product = repo.get_product(image[:id])
    assert_equal 'title', product[:title]
    assert_equal 800, product[:width]
    assert_equal 600, product[:height]

    products = repo.get_product_with_category(image[:category])
    assert_equal 'title', products[0][:title]
    assert_equal 800, products[0][:width]
    assert_equal 600, products[0][:height]

    repo.update_image(item_id: image[:id], title: 'new title', width: 900, height: 700)
    new_image = repo.get_product(image[:id])
    assert_equal new_image[:title], 'new title'
    assert_equal new_image[:width], 900
  end

  test 'create and get video' do
    video = repo.create_video(title: 'title', content: 'content', category: 'category', duration: 60)

    product = repo.get_product(video[:id])
    assert_equal 'title', product[:title]
    assert_equal 60, product[:duration]

    products = repo.get_product_with_category(video[:category])
    assert_equal 'title', products[0][:title]
    assert_equal 60, products[0][:duration]

    repo.update_video(item_id: video[:id], title: 'new title', duration: 120)
    new_video = repo.get_product(video[:id])
    assert_equal new_video[:title], 'new title'
    assert_equal new_video[:duration], 120
  end
end
