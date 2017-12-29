json.id transaction.id
json.extract! transaction,:id, :plot_file_id ,:total_amount,:recieved_amount,:remaining_amount,:target_date,
:created_at,:nature,:mode, :updated_at,:trader_id, :care_of_id, :target_date_in_days, :category_id, :region_id, :is_new

json.children transaction.children.as_json 

json.category do 
	json.fullname transaction.category.fullname
end
json.region do 
	json.title transaction.region.title
end
json.care_of do 
	json.username transaction.care_of.username
end
json.trader do 
	json.username transaction.trader.username
end



