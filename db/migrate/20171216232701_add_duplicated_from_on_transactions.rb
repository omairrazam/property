class AddDuplicatedFromOnTransactions < ActiveRecord::Migration[5.1]
  def change
  	add_reference :transactions, :father, references: :transactions, index: true
	add_foreign_key :transactions, :transactions, column: :father_id
  end
end
