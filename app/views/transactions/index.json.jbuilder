json.data @transactions, partial: 'transactions/transaction', as: :transaction
json.options do
	json.category_id Category.all.reject { |s| s.unit == "cash"}.map{|c|{label:c.fullname, value: c.id}}.unshift({label:'Pick Category', value:-1})
	json.region_id Region.all.map{|r|{label:r.title, value: r.id}}.unshift({label:'Pick Region', value:-1})
	json.mode Transaction.modes.keys.map{|m|{label:beautify_display(m), value: m}}.unshift({label:'Pick mode', value:-1})
	json.buyer_id User.all.map{|u|{label:u.username, value: u.id}}.unshift({label:'Pick a Buyer', value:-1})
	json.seller_id User.all.map{|u|{label:u.username, value: u.id}}.unshift({label:'Pick a Seller', value:-1})
	json.nature Transaction.natures.keys.map{|n|{label:beautify_display(n), value:n}}.unshift({label:'Pick Nature', value:-1})
end


