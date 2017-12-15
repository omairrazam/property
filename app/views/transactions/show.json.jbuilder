json.data [@transaction],partial: 'transactions/transaction', as: :transaction

json.options do
	json.plot_file_id PlotFile.all.map{|f|{label:f.serial_no, value: f.id}}
end