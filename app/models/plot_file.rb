class PlotFile < ApplicationRecord
	has_many :transactions
	has_many :installments
	
	state_machine :state, initial: :pending do
		
	end

end





