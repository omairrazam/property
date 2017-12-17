json.data @categories, partial: 'categories/category', as: :category
json.options do
	json.unit Category.units.keys.map{|a|{label:a.capitalize, value:a}}.unshift({label:'Pick a Category', value:-1})
end