require 'test_helper'

class PriceSimulationsControllerTest < ActionDispatch::IntegrationTest
  test 'prices books' do
    assert_equal 15, get_price(title: 'Title of Book', kind: 'book', isbn: '1', purchase_price: 12, is_hot: false)
  end

  test 'prices images' do
    assert_equal 1, get_price(title: 'Title of Image', kind: 'image', width: 800, height: 600, source: 'NationalGeographic', format: 'jpg')
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
    assert_equal 15.75, get_price(title: 'Title of premium Book', kind: 'book', isbn: '1', purchase_price: 12, is_hot: false)
  end

  private

  def get_price(**params)
    get price_simulation_url, params: params
    response.parsed_body.to_f
  end

  def assert_price_equal(expected, actual)
    assert_in_delta expected, actual, 0.01
  end
end