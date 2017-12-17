class AddDuplicateCountToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :duplicate_count, :integer, :default => 0 
  end
end
