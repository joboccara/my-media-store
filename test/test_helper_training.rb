require "test_helper"

class TestHelperTraining < ActionDispatch::IntegrationTest
  def create_book(title:, content: 'content', isbn: nil, purchase_price: nil, is_hot: nil, created_at: nil)
    Item.create!(kind: 'book', title: title, content: content, created_at: created_at)
  end

  def create_image(title:, content: 'content', width: nil, height: nil, source: nil, format: nil, created_at: nil)
    Item.create!(kind: 'image', title: title, content: content, created_at: created_at)
  end

  def create_video(title:, content: 'content', duration: nil, quality: nil, created_at: nil)
    Item.create!(kind: 'video', title: title, content: content, created_at: created_at)
  end

  def get_product_price(product)
    get '/products'
    assert_equal 200, response.status, response.body
    products_by_kind = response.parsed_body
    product_result = products_by_kind[product.kind.pluralize].find { |p| p['id'] == product.id}
    product_result['price'].to_f
  end

  def assert_price_equal(expected, actual)
    assert_in_delta expected, actual, 0.01
  end
end
