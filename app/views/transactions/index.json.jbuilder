json.data @transactions, partial: 'transactions/transaction', as: :transaction
json.options do
	json.plot_file_id PlotFile.all.map{|f|{label:f.serial_no, value: f.id}}
	json.type User.all.map{|f|{label:f.type, value: f.id}}
end
