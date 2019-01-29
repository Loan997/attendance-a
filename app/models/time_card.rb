class TimeCard < ApplicationRecord
  validates :in_at, format: { with: /([01][0-9]|2[0-3]):[0-5][0-9]/, allow_blank: true }
  validates :out_at, format: { with: /([01][0-9]|2[0-3]):[0-5][0-9]/, allow_blank: true }
  validates :remarks, length: { maximum: 255 }
  validate :both_time_exists, on: :edit
  validate :time_comparison, on: :edit
  
  belongs_to :overtime_application_target, class_name: 'User', :foreign_key => 'overtime_application_target'
  belongs_to :application_targer_for_a_month, class_name: 'User', :foreign_key => 'application_targer_for_a_month'
  belongs_to :applying_attendance_change_target, class_name: 'User', :foreign_key => 'applying_attendance_change_target'
  belongs_to :user
  
  belongs_to :is_overtime_applying, class_name: 'ApplyingState', :foreign_key => 'is_overtime_applying'
  belongs_to :is_attendance_application_for_a_month, class_name: 'ApplyingState', :foreign_key => 'is_attendance_application_for_a_month'
  belongs_to :is_applying_attendance_change, class_name: 'ApplyingState', :foreign_key => 'is_applying_attendance_change'
  
  
  #出社時間と退社時間が前後逆になっていないか
  def time_comparison
    if in_at != nil && out_at != nil then
      if in_at > out_at then
        errors.add(:in_at, "は退社時間以前に設定してください。")
      end
    end
  end
  
  #出社・退社のどちらかの勤怠情報が抜けていないか
  def both_time_exists
    if date < Date.today then
      if (in_at == nil && out_at != nil) || (in_at != nil && out_at == nil) then 
        errors.add(:in_at, "と退社時間の両方を入力してください。")
      end
    end
  end
  
end
