require "test_helper"

class TestHelperTraining < ActionDispatch::IntegrationTest
  def create_book(title:, content: 'content', isbn: nil, purchase_price: nil, is_hot: nil, created_at: nil)
    Book.create!(title: title, content: content, created_at: created_at, isbn: isbn, purchase_price: purchase_price, is_hot: is_hot)
  end

  def create_image(title:, content: 'content', width: nil, height: nil, source: nil, format: nil, created_at: nil)
    Image.create!(title: title, content: content, created_at: created_at, width: width, height: height, source: source, format: format)
  end

  def create_video(title:, content: 'content', duration: nil, quality: nil, created_at: nil)
    Video.create!( title: title, content: content, created_at: created_at, duration: duration, quality: quality)
  end

  def get_product_price(product)
    get '/products'
    assert_equal 200, response.status, response.body
    products_by_kind = response.parsed_body
    product_result = products_by_kind[product.kind.downcase.pluralize].find { |p| p['id'] == product.id}
    product_result['price'].to_f
  end

  def assert_price_equal(expected, actual)
    assert_in_delta expected, actual, 0.01
  end
end
