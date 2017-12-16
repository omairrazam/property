class AddSellerBuyerToTransactions < ActiveRecord::Migration[5.1]
  def change
  	remove_column :transactions, :user_id

	add_reference :transactions, :buyer, references: :users, index: true
	add_foreign_key :transactions, :users, column: :buyer_id

	add_reference :transactions, :seller, references: :users, index: true
	add_foreign_key :transactions, :users, column: :seller_id
  end
end
