# encoding: utf-8
class Transaction < ActiveRecord::Base
  attr_accessible :amount, :transaction_category, :description, :account, :transaction_type, :to_account, :created_at, :tag_list

  acts_as_taggable

  validates :account, :presence => true
  validates :amount, :numericality => true, :allow_blank => false

  belongs_to  :account
  belongs_to  :to_account,  :class_name=>'Account'
  belongs_to  :transaction_category

  after_initialize :init
  after_save       :update_account
  before_save      :revert_account
  before_destroy   :revert_account

  scope :since, lambda {|date| {:conditions=>{:created_at => (date .. Time.now)}}}
  scope :until, lambda {|date| {:conditions=>{:created_at => (Time.at(0) .. date)}}}

  def amount_in_default_currency
    account.currency.to_default_currency amount
  end

  protected

  def init
    self.description  ||= ""
    self.amount ||= 0.0
    self.created_at ||= Time.now
  end

  def revert_account
    @old_transaction = Transaction.find_by_id(self.id)
    return if @old_transaction.nil?

    if @old_transaction.transaction_type == 0
      # if this transaction was transfer, revert for both accounts
      @old_transaction.account.balance += @old_transaction.amount
      @old_transaction.to_account.balance -= @old_transaction.amount
      @old_transaction.to_account.save!
    else
      # otherwise, revert for the main account only
      @old_transaction.account.balance -= @old_transaction.transaction_type * @old_transaction.amount
    end
    @old_transaction.account.save!
  end

  def update_account
    account.reload
    to_account.reload unless to_account.nil?

    if transaction_type != 0
      account.balance = account.balance + transaction_type * amount
    else
      account.balance = account.balance - amount
      to_account.balance = to_account.balance + amount
      to_account.save!
    end
    account.save!
  end

end
