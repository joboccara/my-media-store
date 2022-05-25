class Item < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  TYPES = %w(book image video)
  validates :type, presence: true, inclusion: { in: TYPES }
end
