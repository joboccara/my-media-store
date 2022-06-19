module Pricing
  class Image < Rule
    ParamsDto = Struct.new(:width, :height, :source, :format)

    # @return [Image]
    def initialize
    end

    # @param params [Hash]
    # @return [Boolean]
    def apply?(params)
      params[:kind] == 'image'
    end

    # @param params [Hash]
    # @return [Result<ParamsDto>]
    def parse(params)
      Parser::Struct.new(
        width: Parser::Number.new(&:to_i),
        height: Parser::Number.new(&:to_i),
        source: Parser::Text.new,
        format: Parser::Text.new,
      ).map { |p| ParamsDto.new(p[:width], p[:height], p[:source], p[:format]) }.run(params)
    end

    # @param price [Result<Float>]
    # @param params [ParamsDto]
    # @param now [Time]
    # @return [Result<Float>]
    def compute(price, params, now)
      return Result.failure('Image pricing rule should be first') unless price.pending?
      Result.success(price_image(params.width, params.height, params.source, params.format))
    end

    private

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
