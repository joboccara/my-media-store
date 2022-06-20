# frozen_string_literal: true
class Pricing::ImagePricer
  def call(image)
    national_geographic_price(image) ||
      getty_price(image) ||
      default_price
  end

  private

  def national_geographic_price(image)
    image.resolution * 0.02 / 9600 if image.source == 'NationalGeographic'
  end

  def getty_price(image)
    return unless image.source == 'Getty'
    return 10 if image.format == 'raw'
    return 1 if image.resolution <= 1280 * 720
    return 3 if image.resolution <= 1920 * 1080
    5
  end

  def default_price
    7
  end
end
