require "test_helper"

class TestHelperTraining < ActionDispatch::IntegrationTest
  def create_book(title:, content: 'content', isbn:, purchase_price:, is_hot:)
    repo.create_book(title: title, content: content, isbn: isbn, purchase_price: purchase_price, is_hot: is_hot)
  end

  def create_image(title:, content: 'content', width:, height:, source:, format:)
    repo.create_image(title: title, content: content, width: width, height: height, source: source, format: format)
  end

  def create_video(title:, content: 'content', duration:, quality:)
    repo.create_video(title: title, content: content, duration: duration, quality: quality)
  end

  def repo
    @repo ||= ProductRepository.new
  end
end
