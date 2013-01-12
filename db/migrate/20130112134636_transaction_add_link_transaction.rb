class TransactionAddLinkTransaction < ActiveRecord::Migration
  def up
    add_column :transactions, :link_transaction_id, :integer
  end

  def down
    remove_column :transactions, :link_transaction_id
  end
end
