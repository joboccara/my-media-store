# frozen_string_literal: true
class Products::Video < Products::Product
  attr_accessor :duration, :quality

  def initialize(video)
    super
    @duration = video.duration
    @quality = video.quality
  end
end
