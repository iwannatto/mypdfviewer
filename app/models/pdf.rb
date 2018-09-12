class Pdf < ApplicationRecord
  has_one_attached :pdf
  has_many_attached :jpegs
  
  validates :name, presence: true
end
