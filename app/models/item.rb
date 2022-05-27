class Item < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  KINDS = %w(book image video)
  validates :kind, presence: true, inclusion: { in: KINDS }

  # requires:
  # attribute is_hot? [boolean]
  # attribute purchased_price [float]
  # attribute isbn [string]
end
