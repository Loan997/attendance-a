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
  
  def is_today?(year, month, day)
    return Date.parse("#{year}/#{month}/#{day}") == Date.today
  end
  
  def not_attendance?(user, year, month, day)
    return !TimeCard.find_by(user_id:user, date:Date.strptime("#{year}-#{month}-#{day}", '%Y-%m-%d'))
  end
end
