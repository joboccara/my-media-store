require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  repo = ProductRepository.new

  test 'gets a book with its details' do
    book = repo.create_book(title: 'Item 1', isbn: '1', purchase_price: 42, is_hot: false)

    get product_url(book[:id])

    res = response.parsed_body
    assert_equal 'Item 1', res['title']
    assert_equal 'book', res['kind']
    assert_equal 42, res['purchase_price']
    assert_nil res['width']
    assert_nil res['duration']
  end

  test 'gets an image with its details' do
    image = repo.create_image(title: 'Item 2', width: 800, height: 600, source: 'unknown', format: 'jpg')

    get product_url(image[:id])

    res = response.parsed_body
    assert_equal 'Item 2', res['title']
    assert_equal 'image', res['kind']
    assert_nil res['page_count']
    assert_equal 800, res['width']
    assert_nil res['duration']
  end

  test 'gets an image with its details from an external service' do
    ENV['IMAGES_FROM_EXTERNAL_SERVICE'] = 'true'
    IMAGE_EXTERNAL_ID = 42
    ImageExternalService.expects(:upload_image_details).with(width: 800, height: 600).returns(IMAGE_EXTERNAL_ID)
    ImageExternalService.expects(:get_image_details).with(IMAGE_EXTERNAL_ID).returns({width: 800, height: 600})

    image = repo.create_image(title: 'Item 2', width: 800, height: 600, source: 'unknown', format: 'jpg')

    get product_url(image[:id])

    res = response.parsed_body
    assert_equal 'Item 2', res['title']
    assert_equal 'image', res['kind']
    assert_nil res['page_count']
    assert_equal 800, res['width']
    assert_nil res['duration']
    ENV.delete('IMAGES_FROM_EXTERNAL_SERVICE')
  end

  test 'gets a video with its details' do
    video = repo.create_video(title: 'Item 3', duration: 120, quality: 'FullHD')

    get product_url(video[:id])

    res = response.parsed_body
    assert_equal 'Item 3', res['title']
    assert_equal 'video', res['kind']
    assert_equal 120, res['duration']
    assert_equal 'FullHD', res['quality']
  end

  test 'gets all products' do
    repo.create_book(title: 'Item 1', isbn: '1', purchase_price: 42, is_hot: false)
    repo.create_image(title: 'Item 2', width: 800, height: 600, source: 'unknown', format: 'jpg')
    repo.create_video(title: 'Item 3', duration: 120, quality: 'FullHD')
    repo.create_video(title: 'Item 4', duration: 130, quality: 'FullHD')

    get products_url

    products_by_kind = response.parsed_body

    assert_equal 1, products_by_kind['books'].size
    books = products_by_kind['books']
    assert_equal 'Item 1', books[0]['title']
    assert_equal 42, books[0]['purchase_price']
    
    images = products_by_kind['images']
    assert_equal 1, images.size
    assert_equal 'Item 2', images[0]['title']
    assert_equal 800, images[0]['width']

    videos = products_by_kind['videos']
    assert_equal 2, videos.size
    assert_equal 'Item 3', videos[0]['title']
    assert_equal 120, videos[0]['duration']
    assert_equal 'Item 4', videos[1]['title']
    assert_equal 130, videos[1]['duration']
  end

  test 'get the products of a month' do
    book = repo.create_book(title: 'Title of Book', isbn: '1', purchase_price: 42, is_hot: false, created_at: '2019-01-01')
    video = repo.create_video(title: 'Title of Video', duration: 60, quality: 'FullHD', created_at: '2019-02-01')

    get '/products?month=february', as: :json

    products_by_kind = response.parsed_body
    assert_equal ['videos'], products_by_kind.keys
    videos = products_by_kind['videos']
    assert_equal 'video', videos[0]['kind']
    assert_equal 'Title of Video', videos[0]['title']
  end
end
