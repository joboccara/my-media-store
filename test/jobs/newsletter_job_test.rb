require 'test_helper'

class NewsletterJobTest < ActiveSupport::TestCase
  repo = ProductRepository.new

  test 'it sends a newsletter with the existing products' do
    repo.create_book(title: 'Item 1', content: 'Super item', category: 'star-wars', page_count: 42)
    repo.create_video(title: 'Item 2', content: 'Great item', category: 'star-wars', duration: 120)
    repo.create_image(title: 'Item 3', content: 'Big item', category: 'other', width: 800, height: 600)

    expected_mail_content = <<~MAIL
    star-wars
    Item 1 - book - 42 pages
    Item 2 - video - 120 seconds
    other
    Item 3 - image - 800x600
    MAIL

    mail_sender = mock
    mail_sender.expects(:send_newsletter).with(expected_mail_content)
    NewsletterJob.perform_now(mail_sender)
  end
end