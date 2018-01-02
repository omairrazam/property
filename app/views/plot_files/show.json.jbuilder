json.data [@plot_file]
json.data [@plot_file],partial: 'plot_files/plot_file', as: :plot_file

json.options do
	json.category_id Category.all.map{|c|{label:c.fullname, value: c.id}}
end