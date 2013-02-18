class AddBankIdToBankProduct < ActiveRecord::Migration
  def change
    add_column :bank_products, :bank_id, :integer
  end
end
