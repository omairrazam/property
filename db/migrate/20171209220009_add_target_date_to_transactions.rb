class AddTargetDateToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :target_date, :datetime
  end
end
