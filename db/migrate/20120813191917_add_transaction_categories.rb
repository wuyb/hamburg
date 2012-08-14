# encoding: utf-8
class AddTransactionCategories < ActiveRecord::Migration
  def up
    TransactionCategory.create([
      {name: '衣', transaction_type: -1},
      {name: '食', transaction_type: -1},
      {name: '住', transaction_type: -1},
      {name: '行', transaction_type: -1},
      {name: '其他', transaction_type: -1},
      {name: '工资', transaction_type: +1},
      {name: '奖金', transaction_type: +1},
      {name: '其他', transaction_type: +1}
      ])
  end

  def down
    TransactionCategory.delete_all()
  end
end
