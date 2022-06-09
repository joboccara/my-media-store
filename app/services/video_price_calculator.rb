class VideoPriceCalculator
  def compute(video)
    if video[:quality] == '4k'
        daytime_price = video[:duration] * 0.08
    elsif video[:quality] == 'FullHD'
        daytime_price = started_minutes(video) * 3
    elsif video[:quality] == 'SD'
        daytime_price = [started_minutes(video) * 1, 10].min
    end
    (5 <= Time.now.hour && Time.now.hour < 22) ? daytime_price : daytime_price * 0.6
  end

  def expected_attributes
    [:duration, :quality]
  end

  def parse_attribute(key, value)
    case key
    when 'duration' then value.to_i
    else value
    end
  end

  private

  def started_minutes(video)
    1 + video[:duration].to_i / 60
  end
end