class Category < ApplicationRecord
	has_many :base_amounts, dependent: :destroy
	has_many :plot_files, dependent: :destroy

	def fullname
		size.to_s+unit.to_s
	end
end
