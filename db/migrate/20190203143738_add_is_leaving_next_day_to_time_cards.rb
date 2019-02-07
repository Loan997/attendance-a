class AddIsLeavingNextDayToTimeCards < ActiveRecord::Migration[5.1]
  def change
    add_column :time_cards, :is_leaving_next_day, :boolean
  end
end
