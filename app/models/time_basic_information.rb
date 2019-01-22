class TimeBasicInformation < ApplicationRecord
  validates :designated_working_times,  presence: true
  validates :basic_time,  presence: true
end
