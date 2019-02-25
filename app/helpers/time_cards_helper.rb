module TimeCardsHelper
  
  require "date"
  
  #月の日数を取得
  def get_days
    
    year = params[:year]
    
    if year % 400 == 0 then
      leap_year = true
    elsif year % 100 == 0 then
      leap_year = false
    elsif year % 4 == 0 then
      leap_year = true
    else
      leap_year = false
    end
    
    if leap_year == true && params[:month] == 2 then
      return 29
    else
      month_days = [31,28,31,30,31,30,31,31,30,31,30,31] 
      month = params[:month].to_i
      return month_days[month - 1]
    end
    
  end 
  
  #曜日を取得
  def get_weekday(year, month, day)
    t = Time.new(year, month, day)
    week = %w(日 月 火 水 木 金 土 日)[t.wday]
    return week
  end
  
  #今日の日付か
  def is_today?(year, month, day)
    return Date.parse("#{year}-#{month}-#{day}") == Date.current
  end
  
  #年月日をdate型用フォーマットに変更
  def parse_date_type(year, month, day)
      date_type = Date.parse("#{year}-#{month}-#{day}")
      return date_type
  end
  
  #出社しているか
  def attendance?(user, year, month, day)
    time_card = TimeCard.find_by(user_id:user, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    return time_card && time_card.in_at
  end
  
  #退社しているか
  def leaving?(user, year, month, day)
    time_card = TimeCard.find_by(user_id:user, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    return time_card && time_card.out_at
  end
  
  #出社の時を取得
  def get_hour_in_at(user_id, year, month, day)
    # byebug
    time_card = TimeCard.find_by(user_id:user_id, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    if(time_card == nil || time_card.in_at == nil) then
      return ''
    else
      return time_card.in_at.strftime("%H")
    end
  end
  
  #出社の分を取得
  def get_minute_in_at(user_id, year, month, day)
    time_card = TimeCard.find_by(user_id:user_id, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    if(time_card == nil || time_card.in_at == nil) then
      return ''
    else
      return time_card.in_at.strftime("%M")
    end
  end
  
  #退社の時を取得
  def get_hour_out_at(user_id, year, month, day)
    time_card = TimeCard.find_by(user_id:user_id, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    if(time_card == nil || time_card.out_at == nil) then
      return ''
    else
      return time_card.out_at.strftime("%H")
    end
  end
  
  #退社の分を取得
  def get_minute_out_at(user_id, year, month, day)
    time_card = TimeCard.find_by(user_id:user_id, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    if(time_card == nil || time_card.out_at == nil) then
      return ''
    else
      return time_card.out_at.strftime("%M")
    end
  end
  
  #終了予定時間の時を取得
  def get_hour_end_estimated_time(day)
    time_card = TimeCard.find_by(user_id:current_user.id, date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    if time_card.end_estimated_time.nil?
      return ''
    else
      return time_card.end_estimated_time.strftime("%H")
    end
  end
  
  #終了予定時間の分を取得
  def get_minute_end_estimated_time(day)
    time_card = TimeCard.find_by(user_id:current_user.id, date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    # byebug
    if time_card.end_estimated_time.nil?
      return ''
    else
      return time_card.end_estimated_time.strftime("%M")
    end
  end
  
  # #終了予定時間を取得
  # def get_end_estimated_time(day)
  #   time_card = TimeCard.find_by(user_id: current_user.id, date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
  #   if time_card.end_estimated_time.nil?
  #     return ''
  #   else
  #     return time_card.end_estimated_time
  #   end
  # end
  
  #終了予定時間を取得
  def get_end_estimated_time(user_id, year, month, day)
    # byebug
    time_card = TimeCard.find_by(user_id: user_id, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    if time_card.end_estimated_time.nil?
      return ''
    else
      return time_card.end_estimated_time
    end
  end
  
  #在社時間を取得
  def get_stay_time(user, year, month, day)
    # byebug
    time_card = TimeCard.find_by(user_id:user, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    if(time_card && time_card.out_at && time_card.in_at) then
      # byebug
      if time_card.in_at > time_card.out_at then
        return ((time_card.out_at - time_card.in_at) / 60 / 60).floor(2) + 24
      else
        return ((time_card.out_at - time_card.in_at) / 60 / 60).floor(2)
      end
    else
      return nil
    end
  end
  
  #出社時間を取得
  def get_in_at(day)
    if params[:user_id] then
      time_card = TimeCard.find_by(user_id:params[:user_id], date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    else
      time_card = TimeCard.find_by(user_id:params[:id], date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    end
    if time_card && time_card.in_at then
      return time_card.in_at.strftime('%H:%M')
    else
      return nil
    end
  end
  
  #退社時間を取得
  def get_out_at(day)
    time_card = TimeCard.find_by(user_id:params[:user_id], date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    if time_card && time_card.out_at then
      return time_card.out_at.strftime('%H:%M')
    else
      return nil
    end
  end
  
  #時間外時間を計算
  def off_hours_time(user_id, year, month, day)
    # byebug
    user = User.find(user_id)
    if user.designated_working_end_time && !get_end_estimated_time(user_id, year, month, day).blank?
      time_card = TimeCard.find_by(user_id: user_id, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
      # byebug
      if time_card.next_day.blank?
        return ((get_end_estimated_time(user_id, year, month, day) - user.designated_working_end_time) / 60 / 60).floor(2) - 24
      # byebug
      else
         return ((get_end_estimated_time(user_id, year, month, day) - user.designated_working_end_time) / 60 / 60).floor(2)
      end
      # if user.designated_working_end_time > get_end_estimated_time(day) then
      #   return ((user.designated_working_end_time - get_end_estimated_time(day)) / 60 / 60).floor(2) + 24
      # else
      #   return ((user.designated_working_end_time - get_end_estimated_time(day)) / 60 / 60).floor(2)
      # end
    else
      return ''
    end
  end
  
  #勤怠申請の状態を取得
  def get_is_attendance_application_for_a_month
    # byebug
    if TimeCard.find_by(user_id:params[:user_id], date:Date.strptime("#{params[:year]}-#{params[:month]}-1", '%Y-%m-%d')).is_attendance_application_for_a_month.nil? || 
      TimeCard.find_by(user_id:params[:user_id], date:Date.strptime("#{params[:year]}-#{params[:month]}-1", '%Y-%m-%d')).application_targer_for_a_month.nil?
      return "なし"
    else
      name = TimeCard.find_by(user_id:params[:user_id], date:Date.strptime("#{params[:year]}-#{params[:month]}-1", '%Y-%m-%d')).application_targer_for_a_month.name
      status = TimeCard.find_by(user_id:params[:user_id], date:Date.strptime("#{params[:year]}-#{params[:month]}-1", '%Y-%m-%d')).is_attendance_application_for_a_month.status
      return "#{name} #{status}"
    end
  end
    
  
  
  
  #備考を取得
  def get_remarks(day)
    time_card = TimeCard.find_by(user_id:params[:user_id], date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    if time_card && time_card.remarks  then
      return time_card.remarks
    else
      return nil
    end
  end
  
  #業務内容を取得
  def get_business_outline(day)
    time_card = TimeCard.find_by(user_id:current_user.id, date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    return time_card.business_outline
  end
  
  #残業申請先を取得
  def get_overtime_application_target(day)
    time_card = TimeCard.find_by(user_id:current_user.id, date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    # byebug
    if time_card.overtime_application_target && time_card.is_overtime_applying
      return "残業:#{time_card.overtime_application_target.name} #{time_card.is_overtime_applying.status}"
    else
      return ''
    end
  end
  
  #勤怠変更申請先を取得
  def get_applying_attendance_change_target(day)
    time_card = TimeCard.find_by(user_id:current_user.id, date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    if time_card.applying_attendance_change_target && time_card.is_applying_attendance_change
      return "勤怠変更:#{time_card.applying_attendance_change_target.name} #{time_card.is_applying_attendance_change.status}"
    else
      return ''
    end
  end
  
  #今日よりも未来か判断
  def after_today?(day)
    return "#{params[:year]}-#{params[:month]}-#{day}".to_datetime > Date.current
  end
  
  #出社・退社ボタンの両方が押されているか確認
  def has_pushed_both_button?(day)
    time_card = TimeCard.find_by(user_id:params[:user_id], date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    if params[:user_id] == nil then
      time_card = TimeCard.find_by(user_id:params[:id], date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    end
    return time_card.in_at != nil && time_card.out_at != nil
  end
  
  #どちらのボタンも押されていないか確認
  def has_pushed_no_button?(day)
    time_card = TimeCard.find_by(user_id:params[:user_id], date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    if params[:user_id] == nil then
      time_card = TimeCard.find_by(user_id:params[:id], date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    end
    return time_card.in_at == nil && time_card.out_at == nil
  end
  
  def get_time_cards
    today = Date.current
    @time_cards = TimeCard.where(user_id: params[:id]).where(date: today.in_time_zone.all_month).order("date")
    return @time_cards
  end
  
  #バリデーションエラー件数を取得
  def errors_count(time_cards)
    errors_count = 0
    for time_card in time_cards do
      errors_count += time_card.errors.count
    end
    return errors_count
  end
  
  # 1ヶ月分の所属承認申請がきているか
  def is_attendance_application_for_a_month?
    
    # byebug
    return !TimeCard.where(is_attendance_application_for_a_month: 1)
                    .or(TimeCard.where(is_attendance_application_for_a_month: 2))
                    .where(application_targer_for_a_month: @user.id)
                    .empty?
  end
  
  # 勤怠変更の申請がきているか
  def is_applying_attendance_change?
    # byebug
    return !TimeCard.where(is_applying_attendance_change: 1)
                    .or(TimeCard.where(is_applying_attendance_change: 2))
                    .where(applying_attendance_change_target: @user.id)
                    .empty?
  end
  
  #残業申請の承認申請がきているか
  def is_overtime_applying?
   return !TimeCard.where(is_overtime_applying: 1)
                    .or(TimeCard.where(is_overtime_applying: 2))
                    .where(overtime_application_target: @user.id)
                    .empty?
  end
  
end