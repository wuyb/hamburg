class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :type
      t.string :name
      t.float :balance
      t.float :interest_rate
      t.float :max_credit

      t.timestamps
    end
  end
end
