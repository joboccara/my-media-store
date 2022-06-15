module Pricers
  class ImagePricer < Pricer
    # @return [ImagePricer]
    def initialize
    end

    # @param price [Result<Float>]
    # @param params [Hash]
    # @param now [Time]
    # @return [Result<Float>]
    def compute(price, params, now)
      return price unless params[:kind] == 'image'
      return Result.failure('ImagePricer should be first') unless price.pending?
      parse_params(params).then { |p| price_image(p[:width], p[:height], p[:source], p[:format]) }
    end

    private

    # @param params [Hash]
    # @return [Result<Hash>]
    def parse_params(params)
      required_attrs = [:width, :height, :source, :format]
      missing_attrs = required_attrs.filter { |attr| params[attr].nil? }
      if missing_attrs.length > 0
        Result.failure("missing parameters for pricing images: #{missing_attrs.sort.join(', ')}")
      else
        Result.success({
                         width: params[:width].to_i,
                         height: params[:height].to_i,
                         source: params[:source].to_s,
                         format: params[:format].to_s
                       })
      end
    end

    # @param width [Integer]
    # @param height [Integer]
    # @param source [String]
    # @param format [String]
    # @return [Float]
    def price_image(width, height, source, format)
      pixels = width * height
      if source == 'NationalGeographic'
        0.02 * pixels / 9600
      elsif source == 'Getty'
        return 10.to_f if format == 'raw'
        return 1.to_f if pixels <= 1280 * 720
        return 3.to_f if pixels <= 1920 * 1080
        5.to_f
      else
        7.to_f
      end
    end
  end
end
