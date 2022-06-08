class VideoPriceCalculator
  def compute(video)
    daytime_price = video[:duration] * 0.08 if video[:quality] == '4k'
    (5 <= Time.now.hour && Time.now.hour < 22) ? daytime_price : daytime_price * 0.6
  end
end