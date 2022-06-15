module Pricers
  class VideoPricer < Pricer
    # @return [VideoPricer]
    def initialize
    end

    # @param price [Result<Float>]
    # @param params [Hash]
    # @param now [Time]
    # @return [Result<Float>]
    def compute(price, params, now)
      return price unless params[:kind] == 'video'
      return Result.failure('VideoPricer should be first') unless price.pending?
      parse_params(params).then { |p| price_video(p[:duration], p[:quality], now) }
    end

    private

    # @param params [Hash]
    # @return [Result<Hash>]
    def parse_params(params)
      required_attrs = [:duration, :quality]
      missing_attrs = required_attrs.filter { |attr| params[attr].nil? }
      if missing_attrs.length > 0
        Result.failure("missing parameters for pricing videos: #{missing_attrs.sort.join(', ')}")
      else
        Result.success({
                         duration: params[:duration].to_i,
                         quality: params[:quality].to_s
                       })
      end
    end

    # @param duration [Integer]
    # @param quality [String]
    # @param now [Time]
    # @return [Float]
    def price_video(duration, quality, now)
      started_minutes = 1 + duration / 60
      base_price = if quality == '4k'
                     0.08 * duration
                   elsif quality == 'FullHD'
                     3.to_f * started_minutes
                   elsif quality == 'SD'
                     [10, started_minutes].min.to_f
                   else
                     15.to_f
                   end

      5 <= now.hour && now.hour < 22 ? base_price : base_price * 0.6
    end
  end
end
