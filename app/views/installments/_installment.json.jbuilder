json.id installment.id
json.extract! installment, :id, :plot_file_id, :amount, :created_at, :updated_at
json.plot_file do 
	json.serial_no installment.plot_file.serial_no
end

