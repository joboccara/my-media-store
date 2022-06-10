require "test_helper_training"

class Iteration2Test < TestHelperTraining
  test 'items should have additional details' do
    create_book(title: 'Clean Code', isbn: '9780132350884', purchase_price: 12, is_hot: false)
    create_image(title: 'Manifesto for Agile Software Development', width: 800, height: 600, source: 'Getty', format: 'jpg')
    create_video(title: 'Making Impossible States Impossible', duration: 120, quality: 'FullHD')

    get '/products'
    products_by_kind = response.parsed_body

    book = products_by_kind['books'][0]
    assert_equal 'book', book['kind']
    assert_equal 'Clean Code', book['title']
    assert_equal '9780132350884', book['isbn']
    assert_nil book['purchase_price']
    assert_equal false, book['is_hot']
    assert_nil book['created_at']

    image = products_by_kind['images'][0]
    assert_equal 'image', image['kind']
    assert_equal 'Manifesto for Agile Software Development', image['title']
    assert_equal 800, image['width']
    assert_equal 600, image['height']
    assert_equal 'Getty', image['source']
    assert_equal 'jpg', image['format']
    assert_nil image['created_at']

    video = products_by_kind['videos'][0]
    assert_equal 'video', video['kind']
    assert_equal 'Making Impossible States Impossible', video['title']
    assert_equal 120, video['duration']
    assert_equal 'FullHD', video['quality']
    assert_nil video['created_at']
  end
end
