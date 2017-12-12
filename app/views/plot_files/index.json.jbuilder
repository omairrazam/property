json.data @plot_files, partial: 'plot_files/plot_file', as: :plot_file
json.options do
	json.category_id Category.all.map{|c|{label:c.fullname, value: c.id}}
end
