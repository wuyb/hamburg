class CreateFunds < ActiveRecord::Migration
  def change
    create_table :funds do |t|
      t.string :code
      t.string :name
      t.string :company
      t.float :unit_value
      t.float :unit_value_total
      t.float :increment_rate
      t.float :increment_value
      t.string :managers
      t.boolean :open

      t.timestamps
    end
  end
end
