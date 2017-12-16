class AddBaseAmountToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :base_amount, :integer, :default => 0
  end
end
