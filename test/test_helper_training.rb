require "test_helper"

class TestHelperTraining < ActionDispatch::IntegrationTest
  def create_book(title:, content: 'content', isbn: nil, purchase_price: nil, is_hot: nil, created_at: nil)
    Product.create!(kind: 'book', title: title, content: content, created_at: created_at)
  end

  def create_image(title:, content: 'content', width: nil, height: nil, source: nil, format: nil, created_at: nil)
    Product.create!(kind: 'image', title: title, content: content, created_at: created_at)
  end

  def create_video(title:, content: 'content', duration: nil, quality: nil, created_at: nil)
    Product.create!(kind: 'video', title: title, content: content, created_at: created_at)
  end
end
