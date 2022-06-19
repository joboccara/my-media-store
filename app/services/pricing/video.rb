module Pricing
  class Video < Rule
    ParamsDto = Struct.new(:duration, :quality)

    # @return [Video]
    def initialize
    end

    # @param params [Hash]
    # @return [Boolean]
    def apply?(params)
      params[:kind] == 'video'
    end

    # @param params [Hash]
    # @return [Result<ParamsDto>]
    def parse(params)
      Parser::Struct.new(
        duration: Parser::Number.new(&:to_i),
        quality: Parser::Text.new,
      ).map { |p| ParamsDto.new(p[:duration], p[:quality]) }.run(params)
    end

    # @param price [Result<Float>]
    # @param params [ParamsDto]
    # @param now [Time]
    # @return [Result<Float>]
    def compute(price, params, now)
      return Result.failure('Video pricing rule should be first') unless price.pending?
      Result.success(price_video(params.duration, params.quality))
    end

    private

    # @param duration [Integer]
    # @param quality [String]
    # @return [Float]
    def price_video(duration, quality)
      started_minutes = 1 + duration / 60
      if quality == '4k'
        0.08 * duration
      elsif quality == 'FullHD'
        3.to_f * started_minutes
      elsif quality == 'SD'
        [10, started_minutes].min.to_f
      else
        15.to_f
      end
    end
  end
end
