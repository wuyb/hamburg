class RenameTypeColumnInBankProduct < ActiveRecord::Migration
  def up
    rename_column :bank_products, :type, :type_code
  end

  def down
    rename_column :bank_products, :type_code, :type
  end
end
