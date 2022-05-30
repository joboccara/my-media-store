class Item < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  KINDS = %w(book image video)
  validates :kind, presence: true, inclusion: { in: KINDS }
end
