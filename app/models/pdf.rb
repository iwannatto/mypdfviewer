class Pdf < ApplicationRecord
  has_one_attached :pdf
  
  validates :pdf,
    pdf: true
    
  has_one_attached :jpeg
end
