class CreateTimeCards < ActiveRecord::Migration[5.1]
  def change
    create_table :time_cards do |t|
      t.time :in_at
      t.time :out_at
      t.date :date
      t.references :user, foreign_key: true
    end
  end
end
