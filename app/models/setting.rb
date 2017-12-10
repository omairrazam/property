class Setting 

	def self.file_states
		%i(pending in_stock booked open plot_alloted)
	end

	def self.transaction_types
		%i(bog sop monday)
	end
end