class Stock
	def initialize
	end

	def self.total_property_worth
		Category.distinct_with_plot_files.sum(&:total_worth)
	end

	def self.total_cash
		Category.where(unit: :cash).last.base_amount
	end

	def self.total_worth
		total_property_worth + total_cash
	end

end
