# encoding: utf-8
class Transaction < ActiveRecord::Base
  attr_accessible :amount, :transaction_category, :description, :account, :transaction_type, :link_account, :created_at, :tag_list, :link_transaction
  attr_accessor :transfer_account
  acts_as_taggable

  validates :account, :presence => true
  validates :amount, :numericality => true, :allow_blank => false

  belongs_to  :account
  belongs_to  :link_account,  :class_name=>'Account'
  belongs_to  :transaction_category
  belongs_to  :link_transaction,  :class_name=>'Transaction'

  after_initialize :init
  after_save       :update_account
  before_save      :revert
  before_destroy   :revert
#  before_create    :init_account
#  after_find       :init_transfer_account

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

  def init_transfer_account
    transfer_account = account
  end

  def init_account
    account = transfer_account if !transfer_account.nil?
  end

  def revert
    @old_transaction = Transaction.find_by_id(self.id)
    return if @old_transaction.nil?

    @old_transaction.account.balance -= @old_transaction.transaction_type * @old_transaction.amount
    @old_transaction.account.save!
  end

  def update_account
    account.reload
    account.balance = account.balance + transaction_type * amount
    account.save!
  end

end
