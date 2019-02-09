class CreateApprovalHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :approval_histories do |t|
      t.integer :user_id
      t.time :in_at
      t.time :out_at
      t.date :date
      t.time :previous_in_at
      t.time :previous_out_at
      t.integer :applying_attendance_change_target

      t.timestamps
    end
  end
end
