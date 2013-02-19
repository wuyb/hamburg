class BankProduct < ActiveRecord::Base
  attr_accessible :area, :can_buy, :code, :currency, :end_date, :expiration_date, :fin_date, :incr_investment, :init_investment, :name, :net_value, :risk, :start_date, :status, :style, :term, :type
  belongs_to    :bank
end
