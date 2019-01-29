class AddColumnsToTimeCard < ActiveRecord::Migration[5.1]
  def change
    add_column :time_cards, :end_estimated_time, :time
    add_column :time_cards, :business_outline, :string
    add_column :time_cards, :is_overtime_applying, :integer
    add_column :time_cards, :overtime_application_target, :integer
    add_column :time_cards, :is_attendance_application_for_a_month, :integer
    add_column :time_cards, :application_targer_for_a_month, :integer
    add_column :time_cards, :is_applying_attendance_change, :integer
    add_column :time_cards, :applying_attendance_change_target, :integer
    
  end
end
