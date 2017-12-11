class Category < ApplicationRecord
	has_many :base_amounts, dependent: :destroy
end
