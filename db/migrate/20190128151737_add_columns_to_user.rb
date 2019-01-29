class AddColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :designated_working_start_time, :time
    add_column :users, :designated_working_end_time, :time
    add_column :users, :employee_number, :integer
    add_column :users, :uid, :string
    add_column :users, :basic_time, :time
    add_column :users, :superior, :boolean
  end
end
