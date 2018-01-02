class AddReferencesToTransactions < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :care_of_id
    remove_column :transactions, :trader_id


    #	add_reference :transactions, :buyer, references: :users, index: true
	add_reference :transactions, :care_of, references: :people, index: true
	add_foreign_key :transactions, :people, column: :care_of_id

#	add_reference :transactions, :seller, references: :users, index: true
	add_reference :transactions, :trader, references: :people, index: true
	add_foreign_key :transactions, :people, column: :trader_id
  end
end
