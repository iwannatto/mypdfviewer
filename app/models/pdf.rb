class Pdf < ApplicationRecord
  has_one_attached :pdf
  
  validates :pdf,
    pdf: true
    
  has_many_attached :jpegs
end
