class AddExcelFileToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :excel_file, :string
    add_column :transactions, :imported_from, :integer
    add_column :transactions, :excel_file_name, :string
    add_column :transactions, :transaction_date, :datetime
  end
end
