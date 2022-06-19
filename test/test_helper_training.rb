require "test_helper"

class TestHelperTraining < ActionDispatch::IntegrationTest
  def create_book(title:, content: 'content', isbn: nil, purchase_price: nil, is_hot: nil, created_at: nil)
    book = repo.create_book(title: title, content: content, isbn: isbn, purchase_price: purchase_price, is_hot: is_hot)
    Product.update(book.id, created_at: created_at) unless created_at.nil?
    book
  end

  def create_image(title:, content: 'content', width: nil, height: nil, source: nil, format: nil, created_at: nil)
    image = repo.create_image(title: title, content: content, width: width, height: height, source: source, format: format)
    Product.update(image.id, created_at: created_at) unless created_at.nil?
    image
  end

  def create_video(title:, content: 'content', duration: nil, quality: nil, created_at: nil)
    video = repo.create_video(title: title, content: content, duration: duration, quality: quality)
    Product.update(video.id, created_at: created_at) unless created_at.nil?
    video
  end

  def repo
    @repo ||= ProductRepository.new
  end
end
