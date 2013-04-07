class BankProduct < ActiveRecord::Base
  attr_accessible :area, :can_buy, :code, :currency, :end_date, :expiration_date, :fin_date
  attr_accessible :incr_investment, :init_investment, :name, :net_value, :risk, :start_date
  attr_accessible :status, :style, :term, :type_code, :yearly_interest, :buy_link
  attr_accessible :interest_notes, :end_conditions, :management_fee, :special_notes, :special_sales

  belongs_to    :bank
end
