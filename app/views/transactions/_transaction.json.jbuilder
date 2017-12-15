json.id transaction.id
json.extract! transaction, :id, :plot_file_id, :total_amount, :created_at, :updated_at
json.plot_file do 
	json.serial_no transaction.plot_file.serial_no
end

