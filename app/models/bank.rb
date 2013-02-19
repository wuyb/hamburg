class Bank < ActiveRecord::Base
  attr_accessible :name, :url
  has_many :bank_products
end
