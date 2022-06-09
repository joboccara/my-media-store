require 'test_helper'

class PriceSimulationsControllerTest < ActionDispatch::IntegrationTest
  test 'prices books' do
    assert_price_equal 15, get_price(title: 'Title of Book', kind: 'book', isbn: '1', purchase_price: 12, is_hot: false)
  end

  test 'prices images' do
    assert_price_equal 1, get_price(title: 'Title of Image', kind: 'image', width: 800, height: 600, source: 'NationalGeographic', format: 'jpg')
  end

  test 'prices videos' do
    begin
      Timecop.travel Time.new(2022, 1, 1) + 6.hours
      assert_price_equal 12, get_price(title: 'Title of Video', kind: 'video', duration: 150, quality: '4k')
    ensure
      Timecop.return
    end
  end

  test 'prices with premium' do
    assert_price_equal 15.75, get_price(title: 'Title of premium Book', kind: 'book', isbn: '1', purchase_price: 12, is_hot: false)
  end

  test 'refuses attributes that do not belong to books' do
    error = get_pricing_error(title: 'Title of Book', kind: 'book', isbn: '1')
    assert_equal "missing parameters for pricing books: is_hot, purchase_price", error
  end

  test 'refuses attributes that do not belong to images' do
    error = get_pricing_error(title: 'Title of Image', kind: 'image', width: 800, height: 600, format: 'jpg')
    assert_equal "missing parameters for pricing images: source", error
  end

  test 'refuses attributes that do not belong to videos' do
    error = get_pricing_error(title: 'Title of Video', kind: 'video', quality: '4k')
    assert_equal "missing parameters for pricing videos: duration", error
  end

  test 'refuses params without title' do
    error = get_pricing_error(kind: 'book', isbn: '1')
    assert_equal "missing parameters for pricing books: is_hot, purchase_price, title", error
  end

  private

  def get_price(**params)
    get price_simulation_url, params: params
    res = JSON.parse(response.body)
    assert_equal res.keys, ['price']
    res['price'].to_f
  end

  def get_pricing_error(**params)
    get price_simulation_url, params: params
    res = JSON.parse(response.body)
    assert_equal res.keys, ['error']
    res['error']
  end

  def assert_price_equal(expected, actual)
    assert_in_delta expected, actual, 0.01
  end
end