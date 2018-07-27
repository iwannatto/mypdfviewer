class Pdf < ApplicationRecord
  has_one_attached :pdf
  
  validates :pdf,
    pdf: true
end
