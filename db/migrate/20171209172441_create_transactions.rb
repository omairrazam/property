class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :unique_id
      t.string :temporary_id
      t.references :plot_file, foreign_key: true

      t.timestamps
    end
  end
end
