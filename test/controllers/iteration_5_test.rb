require "test_helper_training"

class Iteration5Test < TestHelperTraining
  test 'it sends a newsletter with the existing products' do
    create_book(title: 'Software craft', isbn: '2100825208', purchase_price: 42, is_hot: false)
    create_image(title: 'XKCD: Good code', width: 800, height: 600, source: 'unknown', format: 'jpg')
    create_video(title: 'Living Documentation : vous allez aimer la documentation', duration: 120, quality: 'HD')

    expected_mail_content = <<~MAIL
    books
    Software craft - 2100825208
    images
    XKCD: Good code - 800x600
    videos
    Living Documentation : vous allez aimer la documentation - 120 seconds
    MAIL

    mail_sender = mock
    mail_sender.expects(:send_newsletter).with(expected_mail_content)
    NewsletterJob.perform_now(mail_sender)
  end

  test 'gets an image with its details from an external service' do
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
