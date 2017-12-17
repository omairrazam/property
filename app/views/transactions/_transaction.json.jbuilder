json.id transaction.id
json.extract! transaction,:id, :plot_file_id ,:total_amount,:recieved_amount,:remaining_amount,:target_date,
:created_at,:nature,:mode, :updated_at,:seller_id, :buyer_id, :target_date_in_days, :category_id, :region_id
json.category do 
	json.fullname transaction.category.fullname
end
json.region do 
	json.title transaction.region.title
end
json.buyer do 
	json.username transaction.buyer.username
end
json.seller do 
	json.username transaction.seller.username
end


