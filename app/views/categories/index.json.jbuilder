json.data @categories, partial: 'categories/category', as: :category
json.options do
	json.unit Category.units.map{|a|{label:a[0].capitalize, value:a[0]}}.unshift({label:'Pick a Category', value:-1})
end