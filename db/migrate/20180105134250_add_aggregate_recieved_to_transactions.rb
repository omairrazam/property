class AddAggregateRecievedToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :aggregate_recieved, :integer
  end
end
