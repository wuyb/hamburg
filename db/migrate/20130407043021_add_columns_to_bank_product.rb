class AddColumnsToBankProduct < ActiveRecord::Migration
  def change
    add_column  :bank_products, :interest_notes,  :string
    add_column  :bank_products, :end_conditions,  :string
    add_column  :bank_products, :management_fee,  :float
    add_column  :bank_products, :special_notes, :string
    add_column  :bank_products, :special_sales, :string
    add_column  :bank_products, :buy_link,  :string
  end
end
