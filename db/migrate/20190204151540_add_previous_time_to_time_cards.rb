class AddPreviousTimeToTimeCards < ActiveRecord::Migration[5.1]
  def change
    add_column :time_cards, :previous_in_at, :time
    add_column :time_cards, :previous_out_at, :time
  end
end
