class RemoveExcelFileNameFromTransactions < ActiveRecord::Migration[5.1]
  def change
    remove_column :transactions, :excel_file_name
  end
end
