class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :base_amount
      t.integer :size
      t.integer :unit

      t.timestamps
    end
  end
end
