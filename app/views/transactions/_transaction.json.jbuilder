json.extract! transaction, :id, :total_amount, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
