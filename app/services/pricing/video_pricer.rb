# frozen_string_literal: true
class Pricing::VideoPricer
  def initialize(now)
    @now = now
  end

  def call(video)
    base_price =
      case video.quality
      when '4k'
        0.08 * video.duration.seconds.to_f
      when 'FullHD'
        3 * started_minutes(video)
      when 'SD'
        [started_minutes(video), 10].min
      else
        15
      end
    apply_hourly_pricing(base_price)
  end

  private

  def apply_hourly_pricing(price)
    @now.hour.between?(5, 21) ? price : price * 0.6
  end

  def started_minutes(video)
    1 + video.duration / 60
  end
end
