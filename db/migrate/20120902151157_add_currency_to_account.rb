class AddCurrencyToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :currency_id, :integer
  end
end
