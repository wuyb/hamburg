class AlterTransactionCategory < ActiveRecord::Migration
  def up
    rename_column :transactions,  :category, :transaction_category_id
    change_column :transactions,  :transaction_category_id, :integer
  end

  def down
    change_column :transactions,  :transaction_category_id, :string
    rename_column :transactions,  :transaction_category_id,  :category
  end
end
