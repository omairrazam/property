class CreateBaseAmounts < ActiveRecord::Migration[5.1]
  def change
    create_table :base_amounts do |t|
      t.integer :amount
      t.datetime :tareekh

      t.timestamps
    end
  end
end
