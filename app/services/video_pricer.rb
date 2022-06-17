# frozen_string_literal: true
class VideoPricer
  def initialize(now)
    @now = now
  end

  def call
    @now.hour.between?(5, 22) ? 15 : 9
  end
end
