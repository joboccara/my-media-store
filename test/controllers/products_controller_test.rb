# frozen_string_literal: true
require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup
    ENV['BOOK_PRICE'] = '8'
  end

  test 'books have a fixed configured price' do
    Item.create(kind: 'book', title: 'Title of Book1', content: 'Contents of Book1')
    Item.create(kind: 'book', title: 'Title of Book2', content: 'Contents of Book2')
    Item.create(kind: 'book', title: 'Title of Book3', content: 'Contents of Book3')
    get products_url

    products = response.parsed_body['books']
    assert_equal ['Title of Book1', 'Title of Book2', 'Title of Book3'], products.map { |p| p['title'] }
    assert_equal 8, products[0]['price']
  end

  test 'videos downloaded have a price depending on the hour, plus 5 if for premium ones' do
    Item.create(kind: 'video', title: 'Video 1 Premium', content: 'Contents of Video 1')
    Item.create(kind: 'video', title: 'Video 2', content: 'Contents of Video 2')

    # 08:00-18:00 -> 12
    # 18:00-00:00 -> 14.99
    # 00:00-08:00 -> 7.99
    Timecop.travel '2022-05-31 08:00' do
      get products_url
      products = response.parsed_body['videos']
      assert_equal 17, products[0]['price']
      assert_equal 12, products[1]['price']
    end

    Timecop.travel '2022-05-31 17:59' do
      get products_url
      products = response.parsed_body['videos']
      assert_equal 17, products[0]['price']
      assert_equal 12, products[1]['price']
    end

    Timecop.travel '2022-05-31 18:00' do
      get products_url
      products = response.parsed_body['videos']
      assert_equal 19.99, products[0]['price']
      assert_equal 14.99, products[1]['price']
    end

    Timecop.travel '2022-05-31 23:59' do
      get products_url
      products = response.parsed_body['videos']
      assert_equal 19.99, products[0]['price']
      assert_equal 14.99, products[1]['price']
    end

    Timecop.travel '2022-05-31 00:00' do
      get products_url
      products = response.parsed_body['videos']
      assert_equal 12.99, products[0]['price']
      assert_equal 7.99, products[1]['price']
    end

    Timecop.travel '2022-05-31 07:59' do
      get products_url
      products = response.parsed_body['videos']
      assert_equal 12.99, products[0]['price']
      assert_equal 7.99, products[1]['price']
    end
  end
end
