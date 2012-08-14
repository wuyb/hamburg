class AlterAccountTypeColumn < ActiveRecord::Migration
  def up
    rename_column :accounts,  :type,  :category
  end

  def down
    rename_column :accounts,  :category,  :type
  end
end
