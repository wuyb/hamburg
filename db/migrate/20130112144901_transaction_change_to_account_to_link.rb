class TransactionChangeToAccountToLink < ActiveRecord::Migration
  def up
    rename_column :transactions,  :to_account_id, :link_account_id
  end

  def down
    rename_column :transactions, :link_account_id,  :to_account_id
  end
end
