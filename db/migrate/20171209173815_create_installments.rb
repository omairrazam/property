class CreateInstallments < ActiveRecord::Migration[5.1]
  def change
    create_table :installments do |t|
      t.integer :amount
      t.datetime :target_date
      t.references :plot_file, foreign_key: true

      t.timestamps
    end
  end
end
