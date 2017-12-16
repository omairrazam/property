class AddTypeToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :nature, :integer
  end
end
