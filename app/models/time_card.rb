class TimeCard < ApplicationRecord
  # validates :in_at, format: { with: /([01]?[0-9]|2[0-3]):([0-5][0-9])/ }
  validates :in_at, numericality: true

  validates :remarks, length: { maximum: 255 }
  

end
