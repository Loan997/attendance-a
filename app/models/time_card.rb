class TimeCard < ApplicationRecord
  validates :in_at, format: { with: /([01][0-9]|2[0-3]):[0-5][0-9]/, allow_blank: true }
  # validates :in_at, numericality: true
  validates :out_at, format: { with: /([01][0-9]|2[0-3]):[0-5][0-9]/, allow_blank: true }
  validates :remarks, length: { maximum: 255 }
  validate :both_time_exists, on: :edit
  validate :time_comparison, on: :edit
  
  
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
