class RemoveColsFromTransactions < ActiveRecord::Migration[5.1]
  def change
  	remove_column :transactions, :status
  end
end
