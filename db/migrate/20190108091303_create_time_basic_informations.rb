class CreateTimeBasicInformations < ActiveRecord::Migration[5.1]
  def change
    create_table :time_basic_informations do |t|
      t.time :designated_working_times
      t.time :basic_time

      t.timestamps
    end
  end
end
