class RemoveColumnStateFromPlotFile < ActiveRecord::Migration[5.1]
  def change
  	remove_column :plot_files, :state
  	add_column :plot_files, :state, :integer
  end
end
