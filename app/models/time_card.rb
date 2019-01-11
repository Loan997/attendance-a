class TimeCard < ApplicationRecord
  validates :remarks, length: { maximum: 255 }
  

end
