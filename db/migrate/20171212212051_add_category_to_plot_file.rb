class AddCategoryToPlotFile < ActiveRecord::Migration[5.1]
  def change
    add_reference :plot_files, :category, foreign_key: true
  end
end
