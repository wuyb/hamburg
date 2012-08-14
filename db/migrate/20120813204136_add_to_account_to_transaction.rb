class AddToAccountToTransaction < ActiveRecord::Migration
  def change
    add_column  :transactions,  :to_account_id,  :integer
  end
end
