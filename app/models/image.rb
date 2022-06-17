# frozen_string_literal: true
class Image < Product

  def resolution
    height * width
  end
end
