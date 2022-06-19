class VideoPriceCalculator
  def compute(video)
    daytime_price = if video[:quality] == '4k'
        video[:duration] * 0.08
    elsif video[:quality] == 'FullHD'
        started_minutes(video) * 3
    elsif video[:quality] == 'SD'
        [started_minutes(video) * 1, 10].min
    else
      15
    end
    (5 <= Time.now.hour && Time.now.hour < 22) ? daytime_price : daytime_price * 0.6
  end

  def expected_attributes
    [:duration, :quality]
  end

  def parse_attribute(key, value)
    key == 'duration' ? value.to_i : value
  end

  private

  def started_minutes(video)
    1 + video[:duration].to_i / 60
  end
end
