class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.float :amount
      t.string :description
      t.string :category

      t.timestamps
    end
  end
end
