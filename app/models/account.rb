class Account < ActiveRecord::Base

  attr_accessible :balance, :interest_rate, :max_credit, :name, :category, :currency

  validates :name, :presence => true, :allow_blank => false
  validates :category, :presence => true
  validates :interest_rate, :numericality => true, :allow_blank => true
  validates :max_credit, :numericality => true, :allow_blank => true
  validates :balance, :numericality => true, :allow_blank => true

  belongs_to  :user
  has_many    :transactions, :dependent => :destroy
  belongs_to  :currency

  after_initialize :init

  def init
    self.balance  ||= 0.0
    self.max_credit  ||= 0.0
    self.interest_rate  ||= 0.0
  end

  def balance_in_default_currency
    currency.to_default_currency balance
  end
end
