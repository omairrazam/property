class RenameBuyerSellerTransactions < ActiveRecord::Migration[5.1]
  def change
  	rename_column :transactions, :buyer_id, :care_of_id
	rename_column :transactions, :seller_id, :trader_id
  end
end
