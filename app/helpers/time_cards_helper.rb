module TimeCardsHelper
  
  require "date"
  
  def get_days(year, month) 
    month_days = [31,28,31,30,31,30,31,31,30,31,30,31] 
    month = month.to_i
    return month_days[month - 1] 
  end 
  
  def get_weekday(year, month, day)
    t = Time.new(year, month, day)
    week = %w(日 月 火 水 木 金 土 日)[t.wday]
    return week
  end
  
  #今日の日付か
  def is_today?(year, month, day)
    return Date.parse("#{year}/#{month}/#{day}") == Date.today
  end
  
  #年月日をdate型用フォーマットに変更
  def parse_date_type(year, month, day)
      date_type = Date.parse("#{year}/#{month}/#{day}")
      return date_type
  end
  
  #出社しているか
  def attendance?(user, year, month, day)
    time_card = TimeCard.find_by(user_id:user, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    return time_card && time_card.in_at
  end
  
  def leaving?(user, year, month, day)
    time_card = TimeCard.find_by(user_id:user, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    return time_card && time_card.out_at
  end
  
  #出社の時を取得
  def get_hour_in_at(user_id, year, month, day)
    time_card = TimeCard.find_by(user_id:user_id, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    if(time_card == nil) then
      return ''
    else
      return time_card.in_at.strftime("%H")
    end
  end
  
  #出社の分を取得
  def get_minute_in_at(user_id, year, month, day)
    time_card = TimeCard.find_by(user_id:user_id, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    if(time_card == nil) then
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
    time_card = TimeCard.find_by(user_id:user, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    if(time_card && time_card.out_at) then
      return ((time_card.out_at - time_card.in_at) / 60 / 60).round(2)
    else
      return nil
    end
  end
  
  #出社時間を取得
  def get_time_card(time_cards, day)
    time_card = time_cards.where(date: Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d')).first
    if time_card then
      time_card = time_card.in_at
    else
      time_card = ''
    end
    return time_card
  end
  
  def get_remarks(day)
    time_card = TimeCard.find_by(user_id:user, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
    if time_card then
      return time_card.remarks
    else
      return nil
    end
  end
end
