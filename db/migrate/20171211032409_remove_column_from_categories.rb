class RemoveColumnFromCategories < ActiveRecord::Migration[5.1]
  def change
  	remove_column :categories, :base_amount
  end
end
