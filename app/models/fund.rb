class Fund < ActiveRecord::Base
  attr_accessible :code, :company, :increment_rate, :increment_value, :managers, :name, :open, :unit_value, :unit_value_total
end
