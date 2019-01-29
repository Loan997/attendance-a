class CreateApplyingStates < ActiveRecord::Migration[5.1]
  def change
    create_table :applying_states do |t|
      t.string :status

      t.timestamps
    end
  end
end
