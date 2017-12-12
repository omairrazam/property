json.id plot_file.id
json.extract! plot_file, :id, :category_id, :serial_no, :created_at, :updated_at
json.category do 
	json.fullname plot_file.category.try(:fullname)
end