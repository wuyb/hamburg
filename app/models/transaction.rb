# encoding: utf-8
class Transaction < ActiveRecord::Base
  attr_accessible :amount, :transaction_category, :description, :account, :transaction_type, :to_account

  validates :account, :presence => true
  validates :amount, :numericality => true, :allow_blank => false

  belongs_to  :account
  belongs_to  :to_account,  :class_name=>'Account'
  belongs_to  :transaction_category

  after_initialize :init
  after_save       :update_account

  protected

  def init
    self.description  ||= ""
    self.amount ||= 0.0
  end

  def update_account
    if transaction_type != 0
      account.balance += transaction_type * amount
    else
      p to_account.name
      account.balance -= amount
      to_account.balance += amount
      to_account.save!
    end
      account.save!
  end
end
