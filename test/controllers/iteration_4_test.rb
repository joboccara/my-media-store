require "test_helper_training"

class Iteration4Test < TestHelperTraining
  test 'price a book' do
    skip 'unskip at iteration 4'
    assert_price_equal 15, get_price(kind: 'book', isbn: '9786612101090', purchase_price: 12)
  end

  test 'price an image' do
    skip 'unskip at iteration 4'
    assert_price_equal 1, get_price(kind: 'image', width: 800, height: 600, source: 'NationalGeographic', format: 'jpg')
  end

  test 'price a video' do
    skip 'unskip at iteration 4'
    begin
      Timecop.travel Time.new(2022, 1, 1) + 6.hours
      assert_price_equal 12, get_price(kind: 'video', duration: 150, quality: '4k')
    ensure
      Timecop.return
    end
  end

  test 'price a premium book' do
    skip 'unskip at iteration 4'
    assert_price_equal 15.75, get_price(kind: 'book', title: 'Clean Ruby premium', isbn: '1484255453', purchase_price: 12)
  end

  test 'return an error with missing attributes sorted alphabetically' do
    skip 'unskip at iteration 4'
    error = get_pricing_error(kind: 'book')
    assert_equal "missing parameters for pricing books: isbn, purchase_price", error

    error = get_pricing_error(kind: 'image', width: 800, height: 600)
    assert_equal "missing parameters for pricing images: format, source", error

    error = get_pricing_error(kind: 'video', quality: '4k')
    assert_equal "missing parameters for pricing videos: duration", error

    error = get_pricing_error(title: 'Title of Book', isbn: '1')
    assert_equal "cannot price product with no kind", error
  end

  private

  def get_price(**params)
    get price_simulation_url, params: params
    assert_equal 200, response.status, response.body
    res = JSON.parse(response.body)
    assert_equal res.keys, ['price']
    res['price'].to_f
  end

  def get_pricing_error(**params)
    get price_simulation_url, params: params
    assert_equal 400, response.status, response.body
    res = JSON.parse(response.body)
    assert_equal res.keys, ['error']
    res['error']
  end
end
