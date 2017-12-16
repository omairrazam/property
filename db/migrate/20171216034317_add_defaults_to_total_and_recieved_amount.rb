class AddDefaultsToTotalAndRecievedAmount < ActiveRecord::Migration[5.1]
  def change
  	change_column :transactions, :total_amount, :integer, :default => 0
  	change_column :transactions, :recieved_amount, :integer, :default => 0
  end
end
