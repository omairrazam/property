json.data @installments, partial: 'installments/installment', as: :installment
json.options do
	json.plot_file_id PlotFile.all.map{|f|{label:f.serial_no, value: f.id}}
end
