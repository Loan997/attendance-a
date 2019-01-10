class AddRemarksToTimeCards < ActiveRecord::Migration[5.1]
  def change
    add_column :time_cards, :remarks, :string
  end
end
