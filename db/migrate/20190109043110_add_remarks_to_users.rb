class AddRemarksToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :remarks, :string
  end
end
