require 'csv'

CSV.generate do |csv|
  csv_column_names = %w(日付 出社時間 退社時間 備考)
     #%w(氏名 アドレス)はrubyのリテラルの一つで、["氏名","アドレス"]と同値になります。
     
  csv << csv_column_names
  @time_cards.each do |time_card|
    csv_column_values = [
      time_card.date,
      time_card.in_at ? time_card.in_at.strftime("%H:%M") : '',
      time_card.out_at
    ]
    csv << csv_column_values
  end
end