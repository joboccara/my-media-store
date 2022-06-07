require 'test_helper'

class NewsletterJobTest < ActiveSupport::TestCase
  repo = ProductRepository.new

  test 'it sends a newsletter with the existing products' do
    repo.create_book(title: 'Item 1', isbn: '1234567890', purchase_price: 42, is_hot: false)
    repo.create_video(title: 'Item 2', duration: 120, quality: 'HD')
    repo.create_image(title: 'Item 3', width: 800, height: 600, source: 'unknown', format: 'jpg')

    expected_mail_content = <<~MAIL
    books
    Item 1 - 1234567890
    videos
    Item 2 - 120 seconds
    images
    Item 3 - 800x600
    MAIL

    mail_sender = mock
    mail_sender.expects(:send_newsletter).with(expected_mail_content)
    NewsletterJob.perform_now(mail_sender)
  end
end