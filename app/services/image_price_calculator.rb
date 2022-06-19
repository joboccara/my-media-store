class ImagePriceCalculator
  def compute(image)
    if image[:source] == 'NationalGeographic'
      pixels(image) * 0.02 / 9600
    elsif image[:source] == 'Getty'
      return 10 if image[:format] ==  'raw'
      if pixels(image) <= 1280 * 720
        1
      elsif pixels(image) <= 1920 * 1080
        3
      else
        5
      end
    else
      7
    end
  end

  def expected_attributes
    [:width, :height, :source, :format]
  end

  def parse_attribute(key, value)
    case key
    when 'width' then value.to_i
    when 'height' then value.to_i
    else value
    end
  end

  private

  def pixels(image)
    image[:width] * image[:height]
  end
end
