class Product < ApplicationRecord
  self.inheritance_column = :kind
  validates :title, presence: true
  validates :content, presence: true

  KINDS = %w(Book Image Video)
  validates :kind, presence: true, inclusion: { in: KINDS }
end
