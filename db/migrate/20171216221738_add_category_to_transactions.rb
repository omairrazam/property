class AddCategoryToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :transactions, :category, foreign_key: true
  end
end
