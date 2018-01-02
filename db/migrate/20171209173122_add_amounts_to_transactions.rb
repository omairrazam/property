class AddAmountsToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :total_amount, :float
    add_column :transactions, :recieved_amount, :float
  end
end
