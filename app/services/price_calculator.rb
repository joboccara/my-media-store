class PriceCalculator

  @strategies = []

  # strategies
  # Books:
  #   If it's in the list of ISBN, apply the pricing catalog
  #   If it is a `hot book`, the price is always 9.99 during week-days
  #   otherwise, the book is sold at +25% margin
  # Videos:
  #   4k videos are sold at 0.08$/second
  #   FullHD videos are sold at 3$/min  per entire minute of video
  #   SD videos are sold at 1$/min per entire minute of video
  #   SD videos longer than 10 minutes do not cost more than 10$
  # Images
  #   Images from NationalGeographic are sold at .02$/9600px
  #   Images from by Getty are sold at
  #     1$ when below 1280x720
  #     then 3$ when below 1920*1080
  #     then 5$ when above FullHD
  #     or 10$ if in RAW format, no matter the resolution

  def initialize
    super
    @strategies.push(PricingStrategies::BooksStrategy.new)
    @strategies.push(PricingStrategies::UniqueBooksStrategy.new)
    @strategies.push(PricingStrategies::HotBooksStrategy.new)
  end

  
  # @param [Item] item
  # @return float
  def compute item
    strategy_for(item).compute(item).to_f
  end

  private
  def strategy_for item
    @strategies
      .filter{|strategy| strategy.support item}
      .sort{|a,b| a.priority <=>b.priority}
      .first
  end
end