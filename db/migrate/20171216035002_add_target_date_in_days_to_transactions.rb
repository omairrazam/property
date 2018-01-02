class AddTargetDateInDaysToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :target_date_in_days, :integer
  end
end
