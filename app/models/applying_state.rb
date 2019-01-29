class ApplyingState < ApplicationRecord
  has_many :is_overtime_applying, class_name: 'TimeCard', :foreign_key => 'is_overtime_applying'
  has_many :is_attendance_application_for_a_month, class_name: 'TimeCard', :foreign_key => 'is_attendance_application_for_a_month'
  has_many :is_applying_attendance_change, class_name: 'TimeCard', :foreign_key => 'is_applying_attendance_change'
end
