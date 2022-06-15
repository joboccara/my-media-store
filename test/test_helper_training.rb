require "test_helper"

class TestHelperTraining < ActionDispatch::IntegrationTest
  def create_book(title:, isbn:, purchase_price:, is_hot:)
    Item.create!(kind: 'book', title: title, content: 'content')
  end

  def create_image(title:, width:, height:, source:, format:)
    Item.create!(kind: 'image', title: title, content: 'content')
  end

  def create_video(title:, duration:, quality:)
    Item.create!(kind: 'video', title: title, content: 'content')
  end
end