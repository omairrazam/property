class AddModeToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :mode, :integer
  end
end
