class AddYearlyInterestToBankProduct < ActiveRecord::Migration
  def change
    add_column  :bank_products, :yearly_interest, :float
  end
end
