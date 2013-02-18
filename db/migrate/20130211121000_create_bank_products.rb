class CreateBankProducts < ActiveRecord::Migration
  def change
    create_table :bank_products do |t|
      t.string :name
      t.string :code
      t.string :type
      t.string :area
      t.string :currency
      t.date :start_date
      t.date :end_date
      t.date :expiration_date
      t.string :status
      t.float :net_value
      t.string :term
      t.string :style
      t.float :init_investment
      t.float :incr_investment
      t.string :risk
      t.date :fin_date
      t.boolean :can_buy

      t.timestamps
    end
  end
end
