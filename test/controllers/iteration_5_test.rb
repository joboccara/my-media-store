require "test_helper_training"

class Iteration5Test < TestHelperTraining
  test 'it sends a newsletter with the existing products' do
    skip 'unskip at iteration 5'
    create_book(title: 'Software craft', isbn: '2100825208', purchase_price: 42, is_hot: false, created_at: Time.parse('2022-05-05 09:18'))
    create_book(title: 'Refactoring: Improving the Design of Existing Code', isbn: '9780134757599', purchase_price: 42, is_hot: false, created_at: Time.parse('2021-04-05'))
    create_image(title: 'XKCD: Good code', width: 800, height: 600, source: 'unknown', format: 'jpg', created_at: Time.parse('2022-05-19 19:32'))
    create_video(title: 'Living Documentation : you will like documentation', duration: 120, quality: 'HD', created_at: Time.parse('2022-05-23 13:01'))
    create_video(title: 'What is DDD - Eric Evans - DDD Europe', duration: 120, quality: 'HD', created_at: Time.parse('2022-06-07 09:18'))

    expected_mail_content = <<~MAIL
    Books
    * Software craft - 2100825208 - 52.50 € 
    Images
    * XKCD: Good code - 800x600 - 7 €
    Videos
    * Living Documentation : you will like documentation - 120 seconds - 15 €
    MAIL

    mail_sender = mock
    mail_sender.expects(:send_newsletter).with(expected_mail_content)
    NewsletterJob.perform_now(from: '2022-05-01', to: '2022-05-31', mail_sender: mail_sender)
  end
end
