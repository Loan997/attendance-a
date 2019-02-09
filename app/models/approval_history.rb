class ApprovalHistory < ApplicationRecord
  belongs_to :user
  belongs_to :applying_attendance_change_target, class_name: 'User', :foreign_key => 'applying_attendance_change_target'
end
