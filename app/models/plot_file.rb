class PlotFile < ApplicationRecord
	has_many :transactions, dependent: :destroy
	has_many :installments, dependent: :destroy
	belongs_to :category

	state_machine :state, initial: :pending do
		
	end

end





