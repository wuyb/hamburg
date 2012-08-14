class CreateTransactionCategories < ActiveRecord::Migration
  def change
    create_table :transaction_categories do |t|
      t.string :name
      t.integer :transaction_type

      t.timestamps
    end
  end
end
