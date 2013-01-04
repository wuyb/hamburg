class Currency < ActiveRecord::Base
  attr_accessible :code, :desc, :rate_to_usd

  def to_default_currency(amount)
    default_currency = Currency.find_by_code('CNY')
    # currently, hard coding the default currency
    default_currency.rate_to_usd * amount / rate_to_usd
  end

end
