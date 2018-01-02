class AddRefToBaseAmount < ActiveRecord::Migration[5.1]
  def change
    add_reference :base_amounts, :category, foreign_key: true
  end
end
