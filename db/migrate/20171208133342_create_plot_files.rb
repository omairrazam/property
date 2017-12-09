class CreatePlotFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :plot_files do |t|
      t.text :serial_no
      t.string :state

      t.timestamps
    end
  end
end
