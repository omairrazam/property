class AddRegionToPlotFile < ActiveRecord::Migration[5.1]
  def change
    add_reference :plot_files, :region, foreign_key: true
  end
end
