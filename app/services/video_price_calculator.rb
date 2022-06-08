class VideoPriceCalculator
  def compute(video)
    if video[:quality] == '4k'
        daytime_price = video[:duration] * 0.08
    elsif video[:quality] == 'FullHD'
        daytime_price = (1 + video[:duration].to_i / 60) * 3
    end
    (5 <= Time.now.hour && Time.now.hour < 22) ? daytime_price : daytime_price * 0.6
  end
end