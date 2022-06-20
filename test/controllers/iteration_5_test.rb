require "test_helper_training"

class Iteration5Test < TestHelperTraining
  test 'it sends a newsletter with the existing products' do
    skip 'unskip at iteration 5'
    create_book(title: 'Software craft', isbn: '2100825208', purchase_price: 42, is_hot: false, created_at: Time.parse('2022-05-05 09:18'))
    create_book(title: 'Refactoring: Improving the Design of Existing Code', isbn: '9780134757599', purchase_price: 42, is_hot: false, created_at: Time.parse('2021-04-05'))
    create_image(title: 'XKCD: Good code', width: 800, height: 600, source: 'unknown', format: 'jpg', created_at: Time.parse('2022-05-19 19:32'))
    create_video(title: 'Living Documentation : you will like documentation', duration: 120, quality: 'HD', created_at: Time.parse('2022-05-23 13:01'))
    create_video(title: 'What is DDD - Eric Evans - DDD Europe', duration: 120, quality: 'HD', created_at: Time.parse('2022-05-31 09:18'))

    expected_mail_content = <<~MAIL
    Books
    * Software craft - 2100825208 - 52.50
    Images
    * XKCD: Good code - 800x600 - 7.00
    Videos
    * Living Documentation : you will like documentation - 120 seconds - 15.00
    MAIL

    mail_sender = mock
    mail_sender.expects(:send_newsletter).with(expected_mail_content)
    NewsletterJob.perform_now(from: '2022-05-01', to: '2022-05-30', mail_sender: mail_sender)
  end

  test 'gets an image with its details from an external service' do
    skip 'unskip at iteration 5'
    begin
      ENV['IMAGES_FROM_EXTERNAL_SERVICE'] = 'true'
      IMAGE_EXTERNAL_ID = 42
      ImageExternalService.expects(:upload_image_details).with(width: 800, height: 600, source: 'Getty', format: 'jpg').returns(IMAGE_EXTERNAL_ID)
      ImageExternalService.expects(:get_image_details).with(IMAGE_EXTERNAL_ID).returns({width: 800, height: 600, source: 'Getty', format: 'jpg'})

      image = create_image(title: 'Item 2', width: 800, height: 600, source: 'Getty', format: 'jpg')

      get products_url

      products_by_kind = response.parsed_body
      image = products_by_kind['images'][0]
      assert_equal 'Item 2', image['title']
      assert_equal 'image', image['kind']
      assert_equal 800, image['width']
    ensure
      ENV.delete('IMAGES_FROM_EXTERNAL_SERVICE')
    end
  end
end
