class AddCommentToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :comment, :text
  end
end
