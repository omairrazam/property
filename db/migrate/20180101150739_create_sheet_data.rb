class CreateSheetData < ActiveRecord::Migration[5.1]
  def change
    create_table :sheet_data do |t|
      t.string :sheet_name
      t.integer :last_processed_index

      t.timestamps
    end
  end
end
