# encoding: utf-8
class RefactorCategories < ActiveRecord::Migration
  def up
    TransactionCategory.find_by_name('衣').update_attribute :name,  '购物'
    TransactionCategory.find_by_name('食').update_attribute :name,  '美食'
    TransactionCategory.find_by_name('住').update_attribute :name,  '生活'
    TransactionCategory.find_by_name('行').update_attribute :name,  '出行'
    TransactionCategory.create([
      {name: '娱乐', transaction_type: -1},
      {name: '丽人', transaction_type: -1},
      {name: '亲子', transaction_type: -1},
      {name: '爱车', transaction_type: -1},
      {name: '健康', transaction_type: -1},
      {name: '宠物', transaction_type: -1}
    ])
  end

  def down
    TransactionCategory.find_by_name('购物').update_attribute :name,  '衣'
    TransactionCategory.find_by_name('美食').update_attribute :name,  '食'
    TransactionCategory.find_by_name('生活').update_attribute :name,  '住'
    TransactionCategory.find_by_name('出行').update_attribute :name,  '行'
    TransactionCategory.find_by_name('娱乐').delete
    TransactionCategory.find_by_name('丽人').delete
    TransactionCategory.find_by_name('亲子').delete
    TransactionCategory.find_by_name('爱车').delete
    TransactionCategory.find_by_name('健康').delete
    TransactionCategory.find_by_name('宠物').delete
  end
end
