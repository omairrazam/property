json.data @plot_files, partial: 'plot_files/plot_file', as: :plot_file
json.options do
	json.category_id Category.all.map{|c|{label:c.fullname, value: c.id}}.unshift({label:'Pick a Category', value:-1})
	json.region_id Region.all.map{|c|{label:c.title, value: c.id}}.unshift({label:'Pick a Region', value:-1})
end
