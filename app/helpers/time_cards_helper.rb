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
  # def get_time_card(time_cards, day)
  #   time_card = time_cards.where(date: Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d')).first
  #   if time_card then
  #     time_card = time_card.in_at
  #   else
  #     time_card = ''
  #   end
  #   return time_card
  # end
  
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
  
  #備考を取得
  def get_remarks(day)
    time_card = TimeCard.find_by(user_id:params[:user_id], date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
    if time_card && time_card.remarks  then
      return time_card.remarks
    else
      return nil
    end
  end
  
  def after_today?(day)
    # byebug
    return "#{params[:year]}-#{params[:month]}-#{day}".to_datetime > Date.today
  end
  
  def get_time_cards
    today = Date.current
    # byebug 
    # test = 1
    @time_cards = TimeCard.where(user_id: params[:id]).where(date: today.in_time_zone.all_month).order("date")
    # byebug
    return @time_cards
  end
  
end
