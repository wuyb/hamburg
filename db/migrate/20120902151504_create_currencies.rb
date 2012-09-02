class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :code
      t.string :desc
      t.float :rate_to_usd

      t.timestamps
    end
  end
end
