class AddRegionToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :region, foreign_key: true
  end
end
