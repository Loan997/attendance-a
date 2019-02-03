class AddNextdayToTimeCards < ActiveRecord::Migration[5.1]
  def change
    add_column :time_cards, :next_day, :boolean
  end
end
