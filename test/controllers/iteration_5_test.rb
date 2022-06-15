require "test_helper_training"

class Iteration5Test < TestHelperTraining
  test 'it sends a newsletter with the existing products' do
    skip 'unskip at iteration 5'
    create_book(title: 'Item 1', isbn: '1234567890', purchase_price: 42, is_hot: false)
    create_image(title: 'Item 2', width: 800, height: 600, source: 'unknown', format: 'jpg')
    create_video(title: 'Item 3', duration: 120, quality: 'HD')

    expected_mail_content = <<~MAIL
    books
    Item 1 - 1234567890
    images
    Item 2 - 800x600
    videos
    Item 3 - 120 seconds
    MAIL

    mail_sender = mock
    mail_sender.expects(:send_newsletter).with(expected_mail_content)
    NewsletterJob.perform_now(mail_sender)
  end
end
